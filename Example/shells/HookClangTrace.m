//
//  HookSymbol.m
//  TestOrder
//
//  Created by iMacHuaSheng on 2021/5/8.
//

#import "HookClangTrace.h"
#import <dlfcn.h>
#import <libkern/OSAtomic.h>
#import <UIKit/UIKit.h>
@implementation HookClangTrace
//+(void)load {
//#ifdef DEBUG
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeTraceOrder) name: UIApplicationDidFinishLaunchingNotification object:nil];
//#endif
//}
//+(void)applicationDidFinishLaunching:(NSNotification *)note {
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self makeTraceOrder];
//    });
//}
+(void)makeTraceOrder {
    NSMutableArray<NSString *> *symbolNames = [NSMutableArray array];
    NSString *excludeSEL = [NSString stringWithFormat:@"[%@ ", NSStringFromClass([self class])];
    while (YES) {
        SYNode *node = OSAtomicDequeue(&symbolist, offsetof(SYNode, next));
        if (node == NULL) {
            NSAssert(symbolNames.count != 0, @"主工程没有配置Build Settings");
            break;
        }
        Dl_info info;
        dladdr(node->pc, &info);
        NSString *name = @(info.dli_sname);
        if (![name containsString:excludeSEL]) {
            BOOL isObjc = [name hasPrefix:@"+["] || [name hasPrefix:@"-["];
            NSString *symbolName = isObjc ? name : [@"_" stringByAppendingString:name];
            [symbolNames addObject:symbolName];
        }
    } 
    NSEnumerator *emt = [symbolNames reverseObjectEnumerator];
    NSString *name;
    NSMutableArray<NSString *> *funcs = [NSMutableArray arrayWithCapacity:symbolNames.count];
    while (name = [emt nextObject]) {
        if (![funcs containsObject:name]) {
            [funcs addObject:name];
        }
    }
    // 将数组变成字符串
    NSString *funcStr = [funcs componentsJoinedByString:@"\n"];
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"hank.order"];
    NSData *fileContents = [funcStr dataUsingEncoding:NSUTF8StringEncoding];
    [[NSFileManager defaultManager] createFileAtPath:filePath contents:fileContents attributes:nil];
    NSLog(@"%@",filePath);
} 
//原子队列(线程安全)
static OSQueueHead symbolist = OS_ATOMIC_QUEUE_INIT;

// 定义符号结构体
typedef struct {
    void *pc;
    void *next;
}SYNode;

extern void __sanitizer_cov_trace_pc_guard_init(uint32_t *start,
                                                    uint32_t *stop) {
  static uint64_t N;  // Counter for the guards.
  if (start == stop || *start) return;  // Initialize only once.
  printf("INIT: %p %p\n", start, stop);
  for (uint32_t *x = start; x < stop; x++)
    *x = (uint32_t)++N;  // Guards should start from 1.
}

extern void __sanitizer_cov_trace_pc_guard(uint32_t *guard) {
    // load 方法重名了 重名为0
//  if (!*guard) return;  // Duplicate the guard check.
  void *PC = __builtin_return_address(0);
    SYNode *node = malloc(sizeof(SYNode));
    *node = (SYNode){PC, NULL};
    // 进入 8: next在结构体SYNode中相对于SYNode的偏移地址
    OSAtomicEnqueue(&symbolist, node, offsetof(SYNode, next));
}
@end
