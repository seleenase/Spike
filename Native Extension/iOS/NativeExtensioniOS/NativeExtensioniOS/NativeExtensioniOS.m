#import "NativeExtensioniOS.h"
#import "FPANEUtils.h"
#import "objc/runtime.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import "HealthKitStore.h"
#import "MuteChecker.h"
#import "Vibrate.h"
#import "PlaySound.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import "FQApi.h"
#import "FQAESUitil.h"
#import "Context.h"
#import "UIKit/UIKit.h"
#import "Trace.h"
#import "G5Api.h"
#import "FQToolsUtil.h"

MuteChecker * _muteChecker;
PlaySound * _soundPlayer;
CLLocationManager * _locationManager;
NSUserDefaults * _userDefaults;

FREObject traceNSLog( FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] ) {
   NSLog(@"%@", FPANE_FREObjectToNSString(argv[0]));
    return NULL;
}

/**********************
 **  MIAOMIAO FUNCTIONS
 *********************/
FREObject ScanAndConnectToMiaoMiaoDevice (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[0]) {
    [FQApi startScaning];
    return nil;
}

FREObject setMiaoMiaoMAC (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[0])
{
    NSString * MAC = [FPANE_FREObjectToNSString(argv[0]) mutableCopy];
    FPANE_Log([NSString stringWithFormat:@"spiketrace ANE NativeExtensioniOS.m in setMiaoMiaoMAC, MAC = : %@", MAC]);
    [FQApi setSelectMAC:MAC];
    return nil;
}

FREObject resetMiaoMiaoMac (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[0])
{
    [FQApi setSelectMAC:NULL];
    return nil;
}

FREObject cancelMiaoMiaoConnectionWithMAC (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[0])
{
    NSString * MAC = [FPANE_FREObjectToNSString(argv[0]) mutableCopy];
    [FQApi cancelConnectWithMAC:MAC];
    return nil;
}

FREObject stopScanningMiaoMiao(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[0]) {
    [FQApi stopScaning];
    return nil;
}

FREObject forgetMiaoMiao(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[0]) {
    [FQApi forgetPeripheral];
    return nil;
}

FREObject sendStartReadingCommmandToMiaoMiao(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[0]) {
    [FQApi sendStartReadingCommand];
    return nil;
}

FREObject startScanDeviceMiaoMiao(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[0]) {
    [FQApi startScanDevice];
    return nil;
}

FREObject stopScanDeviceMiaoMiao(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[0]) {
    [FQApi stopScanDevice];
    return nil;
}

FREObject confirmSensorChangeMiaoMiao(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[0]) {
    [FQApi confirmChange];
    return nil;
}

/**********************
 **  G5 FUNCTIONS
 *********************/
FREObject ScanAndConnectToG5Device (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[0]) {
    [G5Api startScaning];
    return nil;
}

FREObject setG5MAC (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[0])
{
    NSString * MAC = [FPANE_FREObjectToNSString(argv[0]) mutableCopy];
    FPANE_Log([NSString stringWithFormat:@"spiketrace ANE NativeExtensioniOS.m in setG5MAC, MAC = : %@", MAC]);
    [G5Api setSelectMAC:MAC];
    return nil;
}

FREObject resetG5Mac (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[0])
{
    [G5Api setSelectMAC:NULL];
    return nil;
}

FREObject cancelG5ConnectionWithMAC (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[0])
{
    NSString * MAC = [FPANE_FREObjectToNSString(argv[0]) mutableCopy];
    [G5Api cancelConnectWithMAC:MAC];
    return nil;
}

FREObject stopScanningG5(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[0]) {
    [G5Api stopScaning];
    return nil;
}

FREObject forgetG5(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[0]) {
    [G5Api forgetPeripheral];
    return nil;
}

FREObject startScanDeviceG5(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[0]) {
    [G5Api startScanDevice];
    return nil;
}

FREObject stopScanDeviceG5(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[0]) {
    [G5Api stopScanDevice];
    return nil;
}

FREObject setTransmitterIdG5(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[0]) {
    NSString * transmitterId = [FPANE_FREObjectToNSString(argv[0]) mutableCopy];
    NSString * cryptKey = [FPANE_FREObjectToNSString(argv[1]) mutableCopy];
    
    [G5Api setTransmitterIdWithId:transmitterId withCryptKey:cryptKey];
    return nil;
}

FREObject setTestData(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[0]) {
    FREByteArray dataAsByteArray;
    FREAcquireByteArray(argv[0], &dataAsByteArray);
    FREReleaseByteArray(argv[0]);
    NSData * testdata = [NSData dataWithBytes:dataAsByteArray.bytes length:dataAsByteArray.length];
    
    [G5Api setTestData:testdata];
    return nil;
}

FREObject setG5Reset(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[0]) {
    [G5Api setG5Reset:FPANE_FREObjectToBool(argv[0])];
    return nil;
}

FREObject doG5FirmwareVersionRequest(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[0]) {
    [G5Api doG5FirmwareVersionRequest];
    return nil;
}

FREObject doG5BatteryInfoRequest(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[0]) {
    [G5Api doG5BatteryInfoRequest];
    return nil;
}

FREObject disconnectG5(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[0]) {
    [G5Api disconnect];
    return nil;
}

/*************************************
 ** SOUND AND SPEECH RELATED FUNCTIONS
 *************************************/
FREObject playSound (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[0]) {
    [_soundPlayer playSound:[FPANE_FREObjectToNSString(argv[0]) mutableCopy] withVolume:FPANE_FREObjectToInt(argv[1])];
    return nil;
}

FREObject stopPlayingSound (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[0]) {
    FPANE_Log(@"spiketrace ANE NativeExtensioniOS.m stopPlayingSound");
    [_soundPlayer stopPlayingSound];
    return nil;
}

FREObject isPlayingSound (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[0]) {
    return FPANE_BOOLToFREObject([_soundPlayer isPlayingSound]);
}

FREObject say (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[0]) {
    NSString * text = [FPANE_FREObjectToNSString(argv[0]) mutableCopy];
    NSString * language = [FPANE_FREObjectToNSString(argv[1]) mutableCopy];
    [_soundPlayer say:text language:language];
    return nil;
}

FREObject setAvAudioSessionCategory (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[0]) {
    NSString * category = [FPANE_FREObjectToNSString(argv[0]) mutableCopy];
    if ([category isEqualToString:@"AVAudioSessionCategoryAmbient"]) {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryAmbient error:nil];
    } else {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
    }
    return nil;
}

/*********************
 * ** HEALTHKIT
 * *******************/
FREObject initHealthKit (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[0]) {
    FPANE_Log(@"spiketrace ANE NativeExtensioniOS.m initHealthKit");
    [HealthKitStore getInstance:[FPANE_FREObjectToNSString(argv[0]) mutableCopy]];
    return nil;
}

FREObject storeBloodGlucoseValue (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[0]) {
    FPANE_Log(@"spiketrace ANE NativeExtensioniOS.m storeBloodGlucoseValue");
    NSTimeInterval timeInterval = FPANE_FREObjectToDouble(argv[1]);
    [HealthKitStore storeBloodGlucose:FPANE_FREObjectToDouble(argv[0]) dateWithTimeIntervalSince1970:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
    return nil;
}

FREObject storeCarbValue (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[0]) {
    FPANE_Log(@"spiketrace ANE NativeExtensioniOS.m storeCarbValue");
    NSTimeInterval timeInterval = FPANE_FREObjectToDouble(argv[1]);
    [HealthKitStore storeCarbs:FPANE_FREObjectToDouble(argv[0]) dateWithTimeIntervalSince1970:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
    return nil;
}

FREObject storeInsulinValue (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[0]) {
    FPANE_Log(@"spiketrace ANE NativeExtensioniOS.m storeInsulinValue");
    NSTimeInterval timeInterval = FPANE_FREObjectToDouble(argv[1]);
    [HealthKitStore storeInsulinDelivery:FPANE_FREObjectToDouble(argv[0]) dateWithTimeIntervalSince1970:[NSDate dateWithTimeIntervalSince1970:timeInterval] isBolus:FPANE_FREObjectToBool(argv[2])];
    return nil;
}

/***************
 ** APPLICATION
 ***************/
FREObject applicationInBackGround (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[0]) {
    return FPANE_BOOLToFREObject([UIApplication sharedApplication].applicationState != UIApplicationStateActive);
}

FREObject initUserDefaults (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[0])
{
    _userDefaults = [[NSUserDefaults alloc]initWithSuiteName:@"group.org.nightscoutfoundation.spike"];
    [_userDefaults synchronize];
    FPANE_Log(@"spiketrace ANE NativeExtensioniOS.m UserDefaults Initiated!");
    return nil;
}

FREObject setUserDefaultsData (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[0])
{
    [_userDefaults setObject:[FPANE_FREObjectToNSString(argv[1]) mutableCopy] forKey:[FPANE_FREObjectToNSString(argv[0]) mutableCopy]];
    [_userDefaults synchronize];
    return nil;
}

FREObject getAppVersion(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[0]) {
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
    return FPANE_NSStringToFREObject(appVersion);
}

FREObject setDatabaseResetStatus(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[0])
{
    NSString * status = [FPANE_FREObjectToNSString(argv[0]) mutableCopy];
    FPANE_Log([NSString stringWithFormat:@"spiketrace ANE NativeExtensioniOS.m in setDatabaseResetStatus, Database Reset Status = %@", status]);
    
    [FQToolsUtil saveUserDefaults:status key:@"databaseResetted"];
    return nil;
}

FREObject getDatabaseResetStatus(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[0])
{
    BOOL isDatabaseResetted = [[FQToolsUtil userDefaults:@"databaseResetted"] isEqual: @"true"];
    
    FPANE_Log([NSString stringWithFormat:@"spiketrace ANE NativeExtensioniOS.m in getDatabaseResetStatus, Database Reset Status = %s", isDatabaseResetted ? "true" : "false"]);
    
    return FPANE_BOOLToFREObject(isDatabaseResetted);
}

/**********
 ** DEVICE
 **********/
FREObject vibrate(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[0]) {
    FPANE_Log(@"spiketrace ANE NativeExtensioniOS.m vibrate");
    [Vibrate vibrate];
    return nil;
}

FREObject checkMute(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[0]) {
    FPANE_Log(@"spiketrace ANE NativeExtensioniOS.m checkMute");
    [_muteChecker check];
    return nil;
}

FREObject getBatteryLevel(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[0]) {
    FPANE_Log(@"spiketrace ANE NativeExtensioniOS.m getBatteryLevel");
    
    UIDevice *spikeDevice = [UIDevice currentDevice];
    [spikeDevice setBatteryMonitoringEnabled:YES];
    double batteryPercentage = (float)[spikeDevice batteryLevel] * 100;
    
    return FPANE_DoubleToFREObject(batteryPercentage);
}

FREObject getBatteryStatus(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[0]) {
    FPANE_Log(@"spiketrace ANE NativeExtensioniOS.m getBatteryStatus");
    
    UIDevice *spikeDevice = [UIDevice currentDevice];
    [spikeDevice setBatteryMonitoringEnabled:YES];
    int batteryState = [spikeDevice batteryState];
    
    return FPANE_IntToFREObject(batteryState);
}

/************
 ** UTILITIES
 ************/
FREObject generateHMAC_SHA1(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[0]) {
    
    NSString * key = [FPANE_FREObjectToNSString(argv[0]) mutableCopy];
    NSString * data = [FPANE_FREObjectToNSString(argv[1]) mutableCopy];
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *dataData = [data dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *hMacOut = [NSMutableData dataWithLength:CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1,
           keyData.bytes, keyData.length,
           dataData.bytes,    dataData.length,
           hMacOut.mutableBytes);
    
    NSString *hexString = @"";
    if (data) {
        uint8_t *dataPointer = (uint8_t *)(hMacOut.bytes);
        for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
            hexString = [hexString stringByAppendingFormat:@"%02x", dataPointer[i]];
        }
    }
    return FPANE_NSStringToFREObject(hexString);
}

FREObject AESEncryptWithKey(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[0]) {
    
    NSString * key = [FPANE_FREObjectToNSString(argv[0]) mutableCopy];
    
    FREByteArray dataAsByteArray;
    FREAcquireByteArray(argv[1], &dataAsByteArray);
    NSData * dataAsNSData = [NSData dataWithBytes:dataAsByteArray.bytes length:dataAsByteArray.length];
    FREReleaseByteArray(argv[1]);
    
    NSData * encrypted = [FQAESUitil AESEncryptWithKey:key withData:dataAsNSData];
    FREObject returnVaue = argv[2];
    FREByteArray byteArray;
    FREObject length;
    FRENewObjectFromUint32((int)[encrypted length], &length);
    FRESetObjectProperty(returnVaue, (const uint8_t*) "length", length, NULL);
    FREAcquireByteArray(returnVaue, &byteArray);
    
    memcpy(byteArray.bytes, [encrypted bytes], [encrypted length]);
    FREReleaseByteArray(returnVaue);
    
    return nil;
}

FREObject startMonitoringAndRangingBeaconsInRegion (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[0]) {
    NSString * uuid = [FPANE_FREObjectToNSString(argv[0]) mutableCopy];
    CLBeaconRegion * region = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:uuid] major: 1 minor: 1 identifier:@"region1"];
    region.notifyEntryStateOnDisplay = YES;
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager startMonitoringForRegion:region];
    [_locationManager startRangingBeaconsInRegion:region];
    FPANE_Log(@"spiketrace ANE NativeExtensioniOS.m startMonitoringAndRangingBeaconsInRegion");
    return nil;
}

FREObject stopMonitoringAndRangingBeaconsInRegion (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[0]) {
    NSString * uuid = [FPANE_FREObjectToNSString(argv[0]) mutableCopy];
    CLBeaconRegion * region = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:uuid] major: 1 minor: 1 identifier:@"region1"];
    [_locationManager stopMonitoringForRegion:region];
    [_locationManager stopRangingBeaconsInRegion:region];
    FPANE_Log(@"spiketrace ANE NativeExtensioniOS.m stopMonitoringAndRangingBeaconsInRegion");
    return nil;
}

FREObject writeTraceToFile (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[0])
{
    [Trace setFilepath:[FPANE_FREObjectToNSString(argv[0]) mutableCopy]];
    
    NSString *text = [NSString stringWithFormat:@"%@\r\n", [FPANE_FREObjectToNSString(argv[1]) mutableCopy]];
    
    [Trace writeTraceToFile:text];
    
    return nil;
}

FREObject resetTraceFilePath (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[0]) {
    [Trace setFilepath:NULL];
    return nil;
}

/*****************************************
 **  INIT AND FINALIZER FUNCTIONS
 *****************************************/
FREObject init( FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] ) {
    [Context setContext:ctx];

     /** SOUND AND SPEECH RELATED FUNCTIONS **/
    _soundPlayer =[PlaySound alloc];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:YES error:nil];

    /** MUTE CHECKER **/
    _muteChecker = [[MuteChecker alloc] initWithCompletionBlk:^(NSTimeInterval lapse, BOOL muted) {
        if (muted) {
            FREDispatchStatusEventAsync([Context getContext], (const uint8_t*) "phoneMuted", (const uint8_t*) "");
        } else {
            FREDispatchStatusEventAsync([Context getContext], (const uint8_t*) "phoneNotMuted", (const uint8_t*) "");
        }
    }];
    
    return nil;
}

void NativeExtensionInitializer( void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet ) {
    extDataToSet = NULL;
    *ctxInitializerToSet = &NativeExtensionContextInitializer;
    *ctxFinalizerToSet = &NativeExtensionContextFinalizer;
}

void NativeExtensionContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet) {
    
    *numFunctionsToTest = 51;
    
    FRENamedFunction * func = (FRENamedFunction *) malloc(sizeof(FRENamedFunction) * *numFunctionsToTest);

    /*************************
     **  INIT FUNCTIONS
     *************************/
    func[0].name = (const uint8_t*) "init";
    func[0].functionData = NULL;
    func[0].function = &init;
    
    /*************************
     **  NSLOG
     *************************/
    func[1].name = (const uint8_t*) "traceNSLog";
    func[1].functionData = NULL;
    func[1].function = &traceNSLog;

    /**********************
     **  MIAOMIAO FUNCTIONS
     *********************/
    func[2].name = (const uint8_t*) "ScanAndConnectToMiaoMiaoDevice";
    func[2].functionData = NULL;
    func[2].function = &ScanAndConnectToMiaoMiaoDevice;
   
    func[3].name = (const uint8_t*) "setMiaoMiaoMAC";
    func[3].functionData = NULL;
    func[3].function = &setMiaoMiaoMAC;
    
    func[4].name = (const uint8_t*) "resetMiaoMiaoMac";
    func[4].functionData = NULL;
    func[4].function = &resetMiaoMiaoMac;
    
    func[5].name = (const uint8_t*) "cancelMiaoMiaoConnectionWithMAC";
    func[5].functionData = NULL;
    func[5].function = &cancelMiaoMiaoConnectionWithMAC;
    
    func[6].name = (const uint8_t*) "stopScanningMiaoMiao";
    func[6].functionData = NULL;
    func[6].function = &stopScanningMiaoMiao;
    
    func[7].name = (const uint8_t*) "forgetMiaoMiao";
    func[7].functionData = NULL;
    func[7].function = &forgetMiaoMiao;
    
    func[8].name = (const uint8_t*) "sendStartReadingCommmandToMiaoMiao";
    func[8].functionData = NULL;
    func[8].function = &sendStartReadingCommmandToMiaoMiao;
    
    func[9].name = (const uint8_t*) "startScanDeviceMiaoMiao";
    func[9].functionData = NULL;
    func[9].function = &startScanDeviceMiaoMiao;
    
    func[10].name = (const uint8_t*) "stopScanDeviceMiaoMiao";
    func[10].functionData = NULL;
    func[10].function = &stopScanDeviceMiaoMiao;
    
    func[11].name = (const uint8_t*) "confirmSensorChangeMiaoMiao";
    func[11].functionData = NULL;
    func[11].function = &confirmSensorChangeMiaoMiao;

    /*********************
     * ** HEALTHKIT
     * *******************/
    func[12].name = (const uint8_t*) "initHealthKit";
    func[12].functionData = NULL;
    func[12].function = &initHealthKit;
    
    func[13].name = (const uint8_t*) "storeBloodGlucoseValue";
    func[13].functionData = NULL;
    func[13].function = &storeBloodGlucoseValue;

    func[14].name = (const uint8_t*) "storeCarbValue";
    func[14].functionData = NULL;
    func[14].function = &storeCarbValue;
    
    func[15].name = (const uint8_t*) "storeInsulinValue";
    func[15].functionData = NULL;
    func[15].function = &storeInsulinValue;

    /*************************************
     ** SOUND AND SPEECH RELATED FUNCTIONS
     * **********************************/
    func[16].name = (const uint8_t*) "playSound";
    func[16].functionData = NULL;
    func[16].function = &playSound;
    
    func[17].name = (const uint8_t*) "stopPlayingSound";
    func[17].functionData = NULL;
    func[17].function = &stopPlayingSound;

    func[18].name = (const uint8_t*) "isPlayingSound";
    func[18].functionData = NULL;
    func[18].function = &isPlayingSound;

    func[19].name = (const uint8_t*) "say";
    func[19].functionData = NULL;
    func[19].function = &say;

    func[20].name = (const uint8_t*) "setAvAudioSessionCategory";
    func[20].functionData = NULL;
    func[20].function = &setAvAudioSessionCategory;

    /***************
     ** APPLICATION
     ***************/
    func[21].name = (const uint8_t*) "applicationInBackGround";
    func[21].functionData = NULL;
    func[21].function = &applicationInBackGround;
    
    func[22].name = (const uint8_t*) "initUserDefaults";
    func[22].functionData = NULL;
    func[22].function = &initUserDefaults;

    func[23].name = (const uint8_t*) "setUserDefaultsData";
    func[23].functionData = NULL;
    func[23].function = &setUserDefaultsData;

    func[24].name = (const uint8_t*) "getAppVersion";
    func[24].functionData = NULL;
    func[24].function = &getAppVersion;
    
    func[25].name = (const uint8_t*) "setDatabaseResetStatus";
    func[25].functionData = NULL;
    func[25].function = &setDatabaseResetStatus;
    
    func[26].name = (const uint8_t*) "getDatabaseResetStatus";
    func[26].functionData = NULL;
    func[26].function = &getDatabaseResetStatus;

    /**********
     ** DEVICE
     **********/
    func[27].name = (const uint8_t*) "checkMute";
    func[27].functionData = NULL;
    func[27].function = &checkMute;
    
    func[28].name = (const uint8_t*) "vibrate";
    func[28].functionData = NULL;
    func[28].function = &vibrate;
    
    func[29].name = (const uint8_t*) "getBatteryLevel";
    func[29].functionData = NULL;
    func[29].function = &getBatteryLevel;
    
    func[30].name = (const uint8_t*) "getBatteryStatus";
    func[30].functionData = NULL;
    func[30].function = &getBatteryStatus;

    /************
     ** UTILITIES
     ************/
    func[31].name = (const uint8_t*) "generateHMAC_SHA1";
    func[31].functionData = NULL;
    func[31].function = &generateHMAC_SHA1;
    
    func[32].name = (const uint8_t*) "AESEncryptWithKey";
    func[32].functionData = NULL;
    func[32].function = &AESEncryptWithKey;
    
    func[33].name = (const uint8_t*) "startMonitoringAndRangingBeaconsInRegion";
    func[33].functionData = NULL;
    func[33].function = &startMonitoringAndRangingBeaconsInRegion;
    
    func[34].name = (const uint8_t*) "stopMonitoringAndRangingBeaconsInRegion";
    func[34].functionData = NULL;
    func[34].function = &stopMonitoringAndRangingBeaconsInRegion;

    func[35].name = (const uint8_t*) "writeTraceToFile";
    func[35].functionData = NULL;
    func[35].function = &writeTraceToFile;

    func[36].name = (const uint8_t*) "resetTraceFilePath";
    func[36].functionData = NULL;
    func[36].function = &resetTraceFilePath;

    /**********************
     **  G5 FUNCTIONS
     *********************/
    func[37].name = (const uint8_t*) "ScanAndConnectToG5Device";
    func[37].functionData = NULL;
    func[37].function = &ScanAndConnectToG5Device;
    
    func[38].name = (const uint8_t*) "setG5MAC";
    func[38].functionData = NULL;
    func[38].function = &setG5MAC;
   
    func[39].name = (const uint8_t*) "resetG5Mac";
    func[39].functionData = NULL;
    func[39].function = &resetG5Mac;
    
    func[40].name = (const uint8_t*) "cancelG5ConnectionWithMAC";
    func[40].functionData = NULL;
    func[40].function = &cancelG5ConnectionWithMAC;
    
    func[41].name = (const uint8_t*) "stopScanningG5";
    func[41].functionData = NULL;
    func[41].function = &stopScanningG5;
    
    func[42].name = (const uint8_t*) "forgetG5";
    func[42].functionData = NULL;
    func[42].function = &forgetG5;
    
    func[43].name = (const uint8_t*) "startScanDeviceG5";
    func[43].functionData = NULL;
    func[43].function = &startScanDeviceG5;
    
    func[44].name = (const uint8_t*) "stopScanDeviceG5";
    func[44].functionData = NULL;
    func[44].function = &stopScanDeviceG5;
    
    func[45].name = (const uint8_t*) "setTransmitterIdG5";
    func[45].functionData = NULL;
    func[45].function = &setTransmitterIdG5;
    
    func[46].name = (const uint8_t*) "setTestData";
    func[46].functionData = NULL;
    func[46].function = &setTestData;
    
    func[47].name = (const uint8_t*) "setG5Reset";
    func[47].functionData = NULL;
    func[47].function = &setG5Reset;
    
    func[48].name = (const uint8_t*) "doG5FirmwareVersionRequest";
    func[48].functionData = NULL;
    func[48].function = &doG5FirmwareVersionRequest;
   
    func[49].name = (const uint8_t*) "doG5BatteryInfoRequest";
    func[49].functionData = NULL;
    func[49].function = &doG5BatteryInfoRequest;
    
    func[50].name = (const uint8_t*) "disconnectG5";
    func[50].functionData = NULL;
    func[50].function = &disconnectG5;
   
    *functionsToSet = func;
}

void NativeExtensionContextFinalizer( FREContext ctx )
{
    return;
}

void NativeExtensionFinalizer( FREContext ctx )
{
    return;
}

