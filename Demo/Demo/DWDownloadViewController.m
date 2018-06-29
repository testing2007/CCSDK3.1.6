#import "DWDownloadViewController.h"
#import "DWOfflineViewController.h"
#import "DWDownloadTableViewCell.h"

#import "DWOfflineModel.h"
#import "DWDownloadSessionManager.h"
#import "DWDownloadUtility.h"
#import "DWPlayInfo.h"

#import "MJExtension.h"

@interface DWDownloadViewController () <UITableViewDataSource, UITableViewDelegate>
{
    
    NSString *videoid;
}
@property (strong, nonatomic)UITableView *tableView;
@property (copy, nonatomic)NSArray *videoIds;
@property (copy, nonatomic)NSDictionary *playInfo;

@property (nonatomic,strong)NSMutableArray *downingArray;

@property (nonatomic,strong)DWDownloadModel *changeModel;

@property (nonatomic,strong)NSMutableArray *changeModelArray;



@property (nonatomic,strong)NSMutableArray *finishDicArray;
@property (nonatomic,strong)NSMutableArray *downPointArray;//中断的下载任务数组

@property (nonatomic,strong)DWDownloadModel *downloadModel;

@property (nonatomic,assign)BOOL isSameTask;//crash

@property (nonatomic,strong)DWOfflineModel *crashModel;

@property (nonatomic,strong)NSMutableArray *downloadArray;

@property (nonatomic,assign) BOOL isRepeat;

@end

@implementation DWDownloadViewController

- (NSMutableArray *)downloadArray{

    if (!_downloadArray) {
        
        _downloadArray =[NSMutableArray array];
    }

    return _downloadArray;
}

- (NSMutableArray *)downPointArray{

    if (!_downPointArray) {
        
        _downPointArray =[NSMutableArray array];
    }

    return _downPointArray;

}

- (NSMutableArray *)finishDicArray{
 
    if (!_finishDicArray) {
        
        
        _finishDicArray =[NSMutableArray array];
    }

    
    return _finishDicArray;
}

- (NSMutableArray *)downingArray{

    if (!_downingArray) {
        
        _downingArray =[NSMutableArray array];
    }

    return _downingArray;

}



- (NSMutableArray *)changeModelArray{

    if (!_changeModelArray) {
        
        _changeModelArray =[NSMutableArray array];
    }


    return _changeModelArray;

}

+ (instancetype)sharedInstance{

    static id sharedInstance =nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedInstance =[[self alloc] init];
    });
    return sharedInstance;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"下载";
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"下载"
                                                        image:[UIImage imageNamed:@"tabbar-down"]
                                                          tag:0];
        if (IsIOS7) {
            self.tabBarItem.selectedImage = [UIImage imageNamed:@"tabbar-down-selected"];
        }
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    NSLog(@"self.changeModelArray数组为%@",self.changeModelArray);
    

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle:@"离线"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(offlineButtonItemAction:)];
    
    self.navigationItem.rightBarButtonItem = buttonItem;
    
    [self generateTestData];
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    if (!IsIOS7) {
        // 20 为电池栏高度
        // 44 为导航栏高度
        // 49 为标签栏的高度
        frame.size.height = frame.size.height - 20 - 44 - 49;
    }
    self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 60.0f;
    [self.view addSubview:self.tableView];
    logdebug(@"self.view.frame: %@ self.tableView.frame: %@", NSStringFromCGRect(self.view.frame), NSStringFromCGRect(self.tableView.frame));
    

    
    
}




- (void)generateTestData
{
    // TODO: 待下载视频ID列表，可根据需求自定义
    self.videoIds =@[@"84DA0323602FB8799C33DC5901307461", @"5CB9550BBCBAA86F9C33DC5901307461", @"44997A2026B5B04D9C33DC5901307461", @"2FF22C993D872B009C33DC5901307461"];
                     
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.videoIds count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"DWDownloadViewCorollerCellId";
    
    videoid = self.videoIds[indexPath.row];
    
    DWDownloadTableViewCell *cell = (DWDownloadTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[DWDownloadTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
//        [cell.downloadButton addTarget:self action:@selector(offlineButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.downloadButton.tag = indexPath.row;
        cell.downloadButton.enabled =NO;
    }
    
    [cell setupCell:videoid];
    
    return cell;
}

//离线
- (void)offlineButtonItemAction:(UIButton *)button
{
    [self turnOfflineViewController];
}


//下载按钮
- (void)offlineButtonAction:(UIButton *)button
{
    
//    NSInteger indexPath = button.tag;
//    NSString *videoId = self.videoIds[indexPath];
//    
//    DWOfflineViewController *offlineViewController = [[DWOfflineViewController alloc] init];
//    offlineViewController.hidesBottomBarWhenPushed = YES;
//    offlineViewController.videoId = videoId;
//    
//    [self.navigationController pushViewController:offlineViewController animated:NO];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    videoid = self.videoIds[indexPath.row];
    
   //获取下载地址 hlsSupport传@"0"
    DWPlayInfo *playinfo = [[DWPlayInfo alloc] initWithUserId:DWACCOUNT_USERID andVideoId:videoid key:DWACCOUNT_APIKEY hlsSupport:@"0"];
    
    playinfo.mediatype =DWAPPDELEGATE.mediatype;
    //网络请求超时时间
    playinfo.timeoutSeconds =20;
    playinfo.errorBlock = ^(NSError *error){
      
        
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请求资源失败" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
        [sheet showInView:self.view];
        
        
        
    };
    
    playinfo.finishBlock = ^(NSDictionary *response){
        
        NSDictionary *playUrls =[DWUtils parsePlayInfoResponse:response];
        
        if (!playUrls) {
         //说明 网络资源暂时不可用
        }
      
        NSLog(@"---%@",playUrls);
        self.playInfo =playUrls;
        
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择清晰度" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:nil, nil];
        
        NSArray *definitions = [self.playInfo  valueForKey:@"definitionDescription"];
        for (NSString *definition in definitions) {
            [sheet addButtonWithTitle:definition];
        }
        [sheet showInView:self.view];
        
       
    };
    [playinfo start];
    
}



-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //获取PlayInfo 配对url 推送offlineview
    
    NSArray *videos = [self.playInfo valueForKey:@"definitions"];
    
    
    if (buttonIndex != 0) {
        
        NSDictionary *videoInfo = videos[(int)buttonIndex-1];
        //字典转模型
        DWOfflineModel *model =[[DWOfflineModel alloc]init];
        model.definition =[videoInfo objectForKey:@"definition"];
        model.desp =[videoInfo objectForKey:@"desp"];
        model.playurl =[videoInfo objectForKey:@"playurl"];
        model.videoId =videoid;
        model.token =[self.playInfo objectForKey:@"token"];
        
        //判断去重 避免重复下载
        BOOL repeat= [self cleanRepeatModel:model];
        if (repeat) return;
        
        //路径
        // 开始下载
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [paths objectAtIndex:0];
        
        
        /* 注意：
         若你所下载的 videoId 未启用视频加密功能，则保存的文件扩展名[必须]是 mp4，否则无法播放。
         若你所下载的 videoId 启用了视频加密功能，则保存的文件扩展名[必须]是 pcm，否则无法播放。
         */
        NSString *type;
        if ([model.playurl containsString:@"mp4?"]) {
            
            type =@"mp4";
        }else if([model.playurl containsString:@"pcm?"]){
            
            type =@"pcm";
        }else if ([model.playurl containsString:@"m4a?"]){
            
            type =@"m4a";
        }else if ([model.playurl containsString:@"mp3?"]){
            
            type =@"mp3";
        }else if ([model.playurl containsString:@"aac?"]){
            
            type =@"aac";
        }
        
      
        NSString *videoPath;
        if (!model.definition) {
            
            videoPath = [NSString stringWithFormat:@"%@/%@.%@", documentDirectory, model.videoId,type];
        } else {
            
            videoPath = [NSString stringWithFormat:@"%@/%@-%@.%@", documentDirectory, model.videoId, model.definition,type];
        }
        
        model.videoPath =videoPath;
        
       [self trunOfflineViewCtrl:model];
            
        
    }
    
}

//去重
- (BOOL )cleanRepeatModel:(DWOfflineModel *)model{
    
    _isRepeat =NO;
    
    self.downingArray =[[[NSUserDefaults standardUserDefaults] objectForKey:@"downingArray"] mutableCopy];
    self.finishDicArray =[[[NSUserDefaults standardUserDefaults] objectForKey:@"finishDicArray"] mutableCopy];
    
    //先看完成的数组里有没有 再看正在下载的
     [self.finishDicArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *str1 =[NSString stringWithFormat:@"%@",[obj objectForKey:@"videoId"]];
        NSString *str2 =[NSString stringWithFormat:@"%@",[obj objectForKey:@"definition"]];
       
         NSString *str3 =[NSString stringWithFormat:@"%@",model.videoId];
         NSString *str4 =[NSString stringWithFormat:@"%@",model.definition];
         
        
        if ([str1 isEqualToString:str3] && [str2 isEqualToString:str4] ){
            
            
            DWOfflineViewController *offlineViewController = [[DWOfflineViewController alloc]init];
            offlineViewController.showFinishTableHidden =YES;
            offlineViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:offlineViewController animated:NO];
            
            
            _isRepeat =YES;
        }
        
        
    }];
    
    if (_isRepeat) return _isRepeat;
    
    [self.downingArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *str1 =[NSString stringWithFormat:@"%@",[obj objectForKey:@"videoId"]];
        NSString *str2 =[NSString stringWithFormat:@"%@",[obj objectForKey:@"definition"]];
        
        NSString *str3 =[NSString stringWithFormat:@"%@",model.videoId];
        NSString *str4 =[NSString stringWithFormat:@"%@",model.definition];
        
        if ([str1 isEqualToString:str3] && [str2 isEqualToString:str4]){
            
            //有重复的
            DWOfflineViewController *offlineViewController = [[DWOfflineViewController alloc]init];
            offlineViewController.showDowningTable =YES;
            offlineViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:offlineViewController animated:NO];
            
          
            _isRepeat =YES;
            
        }
        
       
    }];
    
   
    return _isRepeat;
}

- (void)trunOfflineViewCtrl:(DWOfflineModel *)model{
    
    
    //开始下载
    [self startDownloadWith:model videoPath:model.videoPath isBegin:YES];
    
    [self turnOfflineViewController];


}

- (void)turnOfflineViewController{


    DWOfflineViewController *offlineViewController = [[DWOfflineViewController alloc]init];
    offlineViewController.hidesBottomBarWhenPushed = YES;
    
    //下载按钮 回调
    [offlineViewController didDownloadBlock:^(DWOfflineModel *model) {
        
        [self changeDownload:model isClick:YES];
        
        
    }];
    //删除 回调
    [offlineViewController didDeleteBlock:^(DWOfflineModel *offlineModel, BOOL isDownloading,NSDictionary *dic) {
        
        if (isDownloading) {
            
          
            //取消相应的下载任务
            [self changeDownload:offlineModel isClick:NO];
            
        }else{
            
            
            [self readDownloadFiles];
            //要用相对路径
            NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
            
            NSString *path =[documentsDirectory stringByAppendingPathComponent:[[dic objectForKey:@"videoPath"] lastPathComponent]];
            
            
            //删除相应的文件
            [[DWDownloadSessionManager manager] deleteAllFileWithDownloadDirectory:path];
            
            [self readDownloadFiles];
            
            
        }
        
    }];
    
    [offlineViewController didStartBlock:^(DWOfflineModel *model) {
        
        [self startDownloadWith:model videoPath:model.videoPath isBegin:NO];
        
    }];
    
    [self.navigationController pushViewController:offlineViewController animated:NO];


}

- (void)readDownloadFiles{


    //读取Docunment下所有文件
    NSArray *fileList = [NSArray array];
    NSFileManager *fileManager =[NSFileManager defaultManager];
    NSError *error;
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    fileList =[fileManager contentsOfDirectoryAtPath:documentsDirectory error:&error];
    NSLog(@"路径==%@,fileList%@___", documentsDirectory,fileList);
    

}



//根据状态切换
- (void)changeDownload:(DWOfflineModel *)model isClick:(BOOL )isClick{
  
    DWDownloadSessionManager *manager = [DWDownloadSessionManager manager];
    
    for (DWDownloadModel *loadmodel in self.changeModelArray) {
        
        if ([loadmodel.downloadURL isEqualToString:model.playurl]) {
            
            _changeModel =loadmodel;
        }
    }
    //_changeModel不存在 说明是crash后的情况
    if (!_changeModel) {
        
        if (model.isDelete) {
            
            //也要删除相应的文件
            [[DWDownloadSessionManager manager] deleteAllFileWithDownloadDirectory:model.videoPath];
        
        }else{
            
            [self startDownloadWith:model videoPath:model.videoPath isBegin:NO];
        }
    
        return;
    }
    
    if (isClick) {
        
        if (_changeModel.state == DWDownloadStateRunning) {
            //暂停
            [manager suspendWithDownloadModel:_changeModel];

        }
        
        
        if (_changeModel.state ==DWDownloadStateSuspended){
            
            //恢复下载
            [manager resumeWithDownloadModel:_changeModel];
            
//          [self startDownloadWith:model videoPath:model.videoPath isBegin:NO];
            
        }
        
  }
    
    //删除相应的下载任务 是否清除已下载的数据
    if (model.isDelete) {
        
        [manager cancleWithDownloadModel:_changeModel isClear:YES];
        
       
    }  
    
    
}


//连接Xcode测试时 app的根目录路径会变 此时下载的文件大小为0 所以测试时不要连接Xcode或者每次拼接最新的Document路径作为model.videoPath
//根据项目需求 逻辑处理
- (void)startDownloadWith:(DWOfflineModel *)model videoPath:(NSString *)videoPath isBegin:(BOOL)isBegin{
    //每次拼接最新的Document路径作为model.videoPath
    NSString *path =videoPath.lastPathComponent;
    NSString *document =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath =[document stringByAppendingPathComponent:path];
    
    //非加密 url videoPath必须有值   token userId videoId 均为nil
    DWDownloadModel *loadModel =[[DWDownloadModel alloc]initWithURLString:model.playurl filePath:filePath responseToken:model.token userId:DWACCOUNT_USERID videoId:model.videoId];
  
    //因为11.3系统的bug URL两小时失效后无法做断点续传 只能重新下载
    float systemVersion =[[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersion <11.3) {
        
        //如果有resumeData 说明是URL失效后的断点续传
        if (model.resumeData) {
            
            loadModel.resumeData =model.resumeData;
        }
    }
    
   
    //放入数组中 用来做暂停 恢复功能 本地保存做删除文件功能 crash后下载等功能 因为changeModelArray里有loadModel.task 所以没法做本地保存 也不必做本地保存
    [self.changeModelArray addObject:loadModel];
    
    if (isBegin) {
        
        // 放入数组 下载中的model数组
        self.downingArray =[[[NSUserDefaults standardUserDefaults] objectForKey:@"downingArray"] mutableCopy];
        [self.downingArray addObject:[model mj_keyValues]];
        [[NSUserDefaults standardUserDefaults] setObject:self.downingArray forKey:@"downingArray"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
  
 
    //下载方法
    [self downloadAction:loadModel offlineModel:model];

  }

- (void)downloadAction:(DWDownloadModel *)loadModel offlineModel:(DWOfflineModel *)model{

    DWDownloadSessionManager *manager =[DWDownloadSessionManager manager];
  
//    manager.isBatchDownload =NO;
//    manager.maxDownloadCount =1;
    
    [manager startWithDownloadModel:loadModel progress:^(DWDownloadProgress *progress,DWDownloadModel *downloadModel) {
        //进度的回调
        if ([downloadModel.downloadURL isEqualToString: model.playurl]) {
            
               //大量开销对象
               @autoreleasepool {
                   
                   model.progressText =[self detailTextForDownloadProgress:progress];
                   model.finishText =[self finishTextForDownloadProgress:progress];
                   model.progress =progress.progress;
                   
                   [[NSNotificationCenter defaultCenter]postNotificationName:@"changeDownload" object:model];
                  NSLog(@"下载__%@__%@__%@__%f",downloadModel.downloadURL,model.progressText,model.finishText,model.progress);
                   
                   
                }
               
               
        }
        
    } state:^(DWDownloadModel *downloadModel,DWDownloadState state, NSString *filePath, NSError *error) {
        
        //下载状态
        if ([downloadModel.downloadURL isEqualToString: model.playurl]){
            
            @autoreleasepool {
                
                model.state =state;
                [[NSNotificationCenter defaultCenter]postNotificationName:@"changeDownload" object:model];
                
            }
            
            //下载完毕
            if (state ==DWDownloadStateCompleted) {
                
                NSDictionary *dic =[model mj_keyValues];
                self.finishDicArray =[[[NSUserDefaults standardUserDefaults] objectForKey:@"finishDicArray"] mutableCopy];
                [self.finishDicArray addObject:dic];
                NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
                [defaults setObject:self.finishDicArray forKey:@"finishDicArray"];
                [defaults synchronize];
                
                //在downingArray删除相应的下载任务
                self.downingArray =[[[NSUserDefaults standardUserDefaults] objectForKey:@"downingArray"] mutableCopy];
                
                // 找到符合条件的 停止 否则会崩溃
               [self.downingArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        if ([[obj objectForKey:@"playurl"] isEqualToString:model.playurl]) {
                           
                            *stop =YES;
                            [self.downingArray removeObject:obj];
                        }
                        
                    }];
                
              
                
                [[NSUserDefaults standardUserDefaults] setObject:self.downingArray forKey:@"downingArray"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"finishDownload" object:model];
                
                
                
                
            }
            
            
            
        }
        
        
    }];


}

- (NSString *)detailTextForDownloadProgress:(DWDownloadProgress *)progress{
    
    NSString *fileSizeInUnits = [NSString stringWithFormat:@"%.2f %@",
                                 [DWDownloadUtility calculateFileSizeInUnit:(unsigned long long)progress.totalBytesExpectedToWrite],
                                 [DWDownloadUtility calculateUnit:(unsigned long long)progress.totalBytesExpectedToWrite]];
    
    NSMutableString *detailLabelText = [NSMutableString stringWithFormat:@" %@\: %.2f %@ (%.2f%%)\nSpeed: %.2f %@/sec\nLeftTime: %dsec",fileSizeInUnits,
                                        [DWDownloadUtility calculateFileSizeInUnit:(unsigned long long)progress.totalBytesWritten],
                                        [DWDownloadUtility calculateUnit:(unsigned long long)progress.totalBytesWritten],progress.progress*100,
                                        [DWDownloadUtility calculateFileSizeInUnit:(unsigned long long) progress.speed],
                                        [DWDownloadUtility calculateUnit:(unsigned long long)progress.speed],progress.remainingTime];
    

    
    return detailLabelText;
    
}

- (NSString *)finishTextForDownloadProgress:(DWDownloadProgress *)progress{
    
    
    NSString *fileSizeInUnits = [NSString stringWithFormat:@"%.2f %@",
                                 [DWDownloadUtility calculateFileSizeInUnit:(unsigned long long)progress.totalBytesExpectedToWrite],
                                 [DWDownloadUtility calculateUnit:(unsigned long long)progress.totalBytesExpectedToWrite]];
    
    return fileSizeInUnits;
    
    
    
}



@end
