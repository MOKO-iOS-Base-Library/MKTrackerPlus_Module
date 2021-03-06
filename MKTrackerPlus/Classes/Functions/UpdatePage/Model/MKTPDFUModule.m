//
//  MKTPDFUModule.m
//  MKTrackerPlus_Example
//
//  Created by aa on 2020/12/29.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import "MKTPDFUModule.h"

#import "MKMacroDefines.h"

#import "MKTPCentralManager.h"

@import iOSDFULibrary;

static NSString *const dfuUpdateDomain = @"com.moko.dfuUpdateDomain";

@interface MKTPDFUModule()<LoggerDelegate, DFUServiceDelegate, DFUProgressDelegate>

@property (nonatomic, copy)void (^progressBlock)(CGFloat progress);

@property (nonatomic, copy)void (^updateSucBlock)(void);

@property (nonatomic, copy)void (^updateFailedBlock)(NSError *error);

@property (nonatomic, strong)DFUServiceController *dfuController;

@end

@implementation MKTPDFUModule

- (void)dealloc{
    NSLog(@"MKTPDFUModule销毁");
}

#pragma mark - DFUServiceDelegate

- (void)updateWithFileUrl:(NSString *)url
            progressBlock:(void (^)(CGFloat progress))progressBlock
                 sucBlock:(void (^)(void))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock{
    if (!ValidStr(url)) {
        [self operationFailedBlock:failedBlock msg:@"The url is invalid!"];
        return;
    }
    NSURL *fileURL = [[NSURL alloc] initWithString:[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
    if (!fileURL) {
        [self operationFailedBlock:failedBlock msg:@"Dfu upgrade failure!"];
        return;
    }
    DFUFirmware *selectedFirmware = [[DFUFirmware alloc] initWithUrlToZipFile:fileURL];// or
    //Use the DFUServiceInitializer to initialize the DFU process.
    if (!selectedFirmware) {
        [self operationFailedBlock:failedBlock msg:@"Dfu upgrade failure!"];
        return;
    }
    DFUServiceInitiator *initiator = [[DFUServiceInitiator alloc] initWithQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) progressQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) loggerQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    initiator = [initiator withFirmware:selectedFirmware];
    initiator.logger = self; // - to get log info
    initiator.delegate = self; // - to be informed about current state and errors
    initiator.progressDelegate = self; // - to show progress bar
    
    self.progressBlock = nil;
    self.progressBlock = progressBlock;
    self.updateSucBlock = nil;
    self.updateSucBlock = sucBlock;
    self.updateFailedBlock = nil;
    self.updateFailedBlock = failedBlock;
    
    self.dfuController = [initiator startWithTarget:[MKTPCentralManager shared].peripheral];
}

- (void)dfuStateDidChangeTo:(enum DFUState)state{
    //升级完成
    if (state==DFUStateCompleted) {
        moko_dispatch_main_safe(^{
            if (self.updateSucBlock) {
                self.updateSucBlock();
            }
        });
    }
    if (state == DFUStateUploading) {
        [MKTPCentralManager sharedDealloc];
    }
}

- (void)dfuError:(enum DFUError)error didOccurWithMessage:(NSString *)message{
    [self operationFailedBlock:self.updateFailedBlock msg:message];
}

#pragma mark - DFUProgressDelegate
- (void)dfuProgressDidChangeFor:(NSInteger)part outOf:(NSInteger)totalParts to:(NSInteger)progress currentSpeedBytesPerSecond:(double)currentSpeedBytesPerSecond avgSpeedBytesPerSecond:(double)avgSpeedBytesPerSecond{
    float currentProgress = (float) progress /totalParts;
    moko_dispatch_main_safe(^{
        if (self.progressBlock) {
            self.progressBlock(currentProgress);
        }
    });
}

#pragma mark - LoggerDelegate
- (void)logWith:(enum LogLevel)level message:(NSString *)message{
    NSLog(@"%logWith ld: %@", (long) level, message);
}

#pragma mark -

- (void)operationFailedBlock:(void (^)(NSError *error))failedBlock msg:(NSString *)msg {
    moko_dispatch_main_safe(^{
        if (failedBlock) {
            NSError *error = [[NSError alloc] initWithDomain:dfuUpdateDomain
                                                        code:-999
                                                    userInfo:@{@"errorInfo":SafeStr(msg)}];
            failedBlock(error);
        }
    });
}

@end
