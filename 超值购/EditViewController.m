//
//  EditViewController.m
//  超值购
//
//  Created by apple on 15/9/3.
//  Copyright (c) 2015年 Flipped. All rights reserved.
//

#import "EditViewController.h"
#import "AddressInfo.h"
#import "DBAddress.h"
#import "Toast.h"
#import "UserInfo.h"
#import "CarTableViewCell.h"
#import "AddressIndex.h"
#import "MyFile.h"


#define VIEWWIDTH [UIScreen mainScreen].bounds.size.width
#define VIEWHIGHT [UIScreen mainScreen].bounds.size.height
extern UserInfo *loginUserInfo;
@interface EditViewController ()
{
    
    IBOutlet UIView *_pickerView;
    IBOutlet UIView *_view;
    IBOutlet UITextField *_tfName;

    IBOutlet UIPickerView *_pickerHomeView;
    IBOutlet UILabel *_lbArea;
    IBOutlet UITextField *_tfPhone;
    
    IBOutlet UITextField *_tfAddress;
    UIButton *btn;
    NSDictionary *_areaDic;
    NSMutableArray *_provinceArray;
    NSMutableArray *_cityArray;
     NSMutableArray *_countyArray;
    NSString *selectProvince;
     NSString *selectCity;
     NSString *selectCounty;
    int provinceIndex;
     int cityIndex;
     int countyIndex;
    NSDictionary *_cityDic;
    NSArray *cityArray;
    AddressIndex *infoIndex;
    AddressInfo *infoIndex1;
}
- (IBAction)areaAction:(id)sender;
- (IBAction)closeAction:(id)sender;
- (IBAction)DoneAction:(id)sender;

- (IBAction)sureClick:(id)sender;

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    infoIndex=[AddressIndex new];
    if (_info!=nil) {
        _tfName.text=_info.Address_name;
        _tfPhone.text=_info.Address_phone;
        _tfAddress.text=_info.Address_street;
        selectProvince=_info.Address_province;

        _lbArea.text=[NSString stringWithFormat:@"%@%@%@",_info.Address_province,_info.Address_city,_info.Address_district];
        self.title=@"编辑收货地址";
       infoIndex1=[[DBAddress sharedInfo] getAddressIndex:_info.Address_id userId:loginUserInfo.user_id];
        provinceIndex=infoIndex1.province;
        cityIndex=infoIndex1.city;
        [self loadArray];
        [_pickerHomeView selectRow:infoIndex1.province inComponent:0 animated:NO];
        [_pickerHomeView selectRow:infoIndex1.city inComponent:1 animated:NO];
        [_pickerHomeView selectRow:infoIndex1.county inComponent:2 animated:NO];
        
       
    }else {
        _tfName.text=@"";
        _tfPhone.text=@"";
        _tfAddress.text=@"";
        self.title=@"增加收货地址";
        provinceIndex=0;
        cityIndex=0;
//        selectProvince=@"北京";
        [self loadArray];

    }
   
    
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(0, 0, 28, 20)];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"all_back"] forState:UIControlStateNormal];
    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    leftBtn.showsTouchWhenHighlighted=YES;
    [leftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=item;
    
    btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, VIEWWIDTH, VIEWHIGHT)];
    [btn setBackgroundColor:[UIColor darkGrayColor]];
    btn.alpha=0.5;
    [btn addTarget:self action:@selector(closeBtn) forControlEvents:UIControlEventTouchUpInside];
    [_view addSubview:btn];
    btn.hidden=YES;
    
    [_pickerView setFrame:CGRectMake(0, VIEWHIGHT, VIEWWIDTH, 201)];
    [_view addSubview:_pickerView];
    UITapGestureRecognizer *singer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    singer.numberOfTapsRequired=1;
    [self.view addGestureRecognizer:singer];
    
}
-(void)loadArray{
    _provinceArray=[NSMutableArray array];//省数组
    _cityArray=[NSMutableArray array];//城市数组
    _countyArray=[NSMutableArray array];//县级数组
    NSString *plistPath=[[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
    _areaDic=[[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSArray *sortedArray=[[_areaDic allKeys] sortedArrayUsingComparator:^(id obj1, id obj2) {
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return NSOrderedDescending;//下降
        }else if ([obj1 integerValue] < [obj2 integerValue]){
            return NSOrderedAscending;//上升
        }else {
            return NSOrderedSame;//一样
        }
    }];

    for (int i=0; i<sortedArray.count; i++) {
        NSDictionary *dic=[_areaDic objectForKey:[sortedArray objectAtIndex:i]];
        [_provinceArray addObject:[[dic allKeys] objectAtIndex:0]];
    }
    /*------自己思路-----*/
    

//    NSLog(@"=== %@",_provinceArray);
//    NSDictionary *dic=[_areaDic objectForKey:[sortedArray objectAtIndex:provinceIndex]];
//    
//    
//    cityDic=[dic objectForKey:[_provinceArray objectAtIndex:provinceIndex]];
//    
//    cityArray=[[cityDic allKeys] sortedArrayUsingComparator:^(id obj1, id obj2) {
//        if ([obj1 integerValue] > [obj2 integerValue]) {
//            return NSOrderedDescending;//下降
//        }else if ([obj1 integerValue] < [obj2 integerValue]){
//            return NSOrderedAscending;//上升
//        }else {
//            return NSOrderedSame;//一样
//        }
//    }
//                        ];
//    for (int i=0; i<cityArray.count; i++) {
//        NSDictionary *Citydic=[cityDic objectForKey:[cityArray objectAtIndex:i]];
//        [_cityArray addObject:[[Citydic allKeys] objectAtIndex:0]];//市数组
//    }
//    NSLog(@"%@",_cityArray);
//    if (selectCity==nil) {
//        selectCity=[_cityArray objectAtIndex:0];
//    }
//    
//    NSDictionary *shiDic=[cityDic objectForKey:[cityArray objectAtIndex:cityIndex]];
//    _countyArray=[shiDic objectForKey:[_cityArray objectAtIndex:cityIndex]];
//    NSLog(@"%@",_countyArray);
    /*------自己思路-----*/

    NSDictionary *dic=[_areaDic objectForKey:[NSString stringWithFormat:@"%i",provinceIndex]];//取出字典里面对应的Key的市级字典（省里面包含的）。
    _cityDic=[dic objectForKey:[_provinceArray objectAtIndex:provinceIndex]];//通过dic找里面相对性的市区的名字，返回一个市区的字典。
    _cityArray=[NSMutableArray array];
    for (int i=0; i<_cityDic.count; i++) {
        NSDictionary *dic=[_cityDic objectForKey:[NSString stringWithFormat:@"%i",i]];
        [_cityArray addObject:[[dic allKeys] objectAtIndex:0]];
    }//遍历取出市区的数组
    _countyArray=[NSMutableArray array];
    NSDictionary *districtArray=[_cityDic objectForKey:[NSString stringWithFormat:@"%i",cityIndex]];
    _countyArray=[districtArray objectForKey:[_cityArray objectAtIndex:cityIndex]];//取出区的数组，默认为第一个
    NSLog(@"aaaaa%i",cityIndex);
    NSLog(@"%@",_countyArray);

}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
   
    
    
    if (component==0) {
        return _provinceArray.count;
    }else if (component==1){
       
        return _cityArray.count;
    }else{
        return _countyArray.count;
    }
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component==0) {
        return [_provinceArray objectAtIndex:row];
    }else if (component==1){
        return [_cityArray objectAtIndex:row];
    }else if(component==2){
        return [_countyArray objectAtIndex:row];
    }
    return nil;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component==0) {//根据行数的变化所选择的城市不同，刷新列表。
        /*------自己思路-----*/
//        selectProvince=[_provinceArray objectAtIndex:row];
//         provinceIndex=(int)row;
//        [self loadArray];
//        NSDictionary *shiDic=[cityDic objectForKey:[cityArray objectAtIndex:0]];
//        selectCity=[_cityArray objectAtIndex:0];
//        _countyArray=[shiDic objectForKey:selectCity];
//
//        selectCounty=[_countyArray objectAtIndex:0];
        /*------自己思路-----*/
        
        provinceIndex=(int)row;
        cityIndex=0;
        countyIndex=0;//默认为第0行。
        [self loadArray];
        selectProvince=[_provinceArray objectAtIndex:row];
        selectCity=[_cityArray objectAtIndex:0];
        selectCounty=[_countyArray objectAtIndex:0];
        [_pickerHomeView reloadComponent:1];
        [_pickerHomeView reloadComponent:2];
        [_pickerHomeView selectRow:0 inComponent:1 animated:YES];
        [_pickerHomeView selectRow:0 inComponent:2 animated:YES];
       
    }
    if (component==1) {//根据行数的变化所选择的城市不同，刷新列表。
        /*------自己思路-----*/
//        selectCity=[_cityArray objectAtIndex:row];
//        cityIndex=(int)row;
//        [self loadArray];
         /*------自己思路-----*/
        
        
        /*------老师思路-----*/
        selectCity=[_cityArray objectAtIndex:row];
        cityIndex=(int)row;
        NSLog(@"bbbb%i",cityIndex);
        NSDictionary *districtArray=[_cityDic objectForKey:[NSString stringWithFormat:@"%li",row]];
        _countyArray=[districtArray objectForKey:[_cityArray objectAtIndex:row]];
        /*------老师思路-----*/
        
        countyIndex=0;
        [_pickerHomeView reloadComponent:2];
      [_pickerHomeView selectRow:0 inComponent:2 animated:YES];
        selectCounty=[_countyArray objectAtIndex:0];
        
      
    }
    if (component==2) {//根据行数的变化所选择的城市不同，刷新列表。
        selectCounty=[_countyArray objectAtIndex:row];
        selectCity= [_cityArray objectAtIndex:infoIndex1.city];
        countyIndex=(int)row;
 
        
    }
    NSLog(@"----%i",provinceIndex);
    NSLog(@"++++%i",cityIndex);
    NSLog(@"....%i",countyIndex);
    NSLog(@"===%@,%@%@",selectProvince,selectCity,selectCounty);
    _lbArea.text=[NSString stringWithFormat:@"%@%@%@",selectProvince,selectCity,selectCounty];
}

-(void)tapAction{
    [_tfName resignFirstResponder];
    [_tfAddress resignFirstResponder];
    [_tfPhone resignFirstResponder];
    [self.view setFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height)];
}

-(void)viewDidAppear:(BOOL)animated{
    [_tfName becomeFirstResponder];
}
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)closeBtn{
    [_tfName resignFirstResponder];
    [_tfAddress resignFirstResponder];
    [_tfPhone resignFirstResponder];
    [UIView animateWithDuration:1//动画持续时间
                          delay:0.0//动画延迟时间
         usingSpringWithDamping:1//动画类似弹簧震动效果0-1
          initialSpringVelocity:2//动画初始速度
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         [_pickerView setFrame:CGRectMake(0, VIEWHIGHT, VIEWWIDTH, 201)];
                     }
                     completion:^(BOOL finished){
                     }];
    
    btn.hidden=YES;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return VIEWHIGHT;

}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return _view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *celled=@"cell";
    CarTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:celled];
    if (cell==nil) {
        NSArray *array=[[NSBundle mainBundle] loadNibNamed:@"CarTableViewCell" owner:self options:nil];
        cell=[array objectAtIndex:0];
    }
        return cell;

    
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [_tfName resignFirstResponder];
    [_tfAddress resignFirstResponder];
    [_tfPhone resignFirstResponder];
}
- (IBAction)areaAction:(id)sender {
    [_tfName resignFirstResponder];
    [_tfAddress resignFirstResponder];
    [_tfPhone resignFirstResponder];
    [UIView animateWithDuration:1//动画持续时间
                          delay:0.0//动画延迟时间
         usingSpringWithDamping:1//动画类似弹簧震动效果0-1
          initialSpringVelocity:2//动画初始速度
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                          [_pickerView setFrame:CGRectMake(0, 400, VIEWWIDTH, 201)];
                     }
                     completion:^(BOOL finished){
                     }];
    
    btn.hidden=NO;
}

- (IBAction)closeAction:(id)sender {
    btn.hidden=YES;
    [UIView animateWithDuration:1//动画持续时间
                          delay:0.0//动画延迟时间
         usingSpringWithDamping:1//动画类似弹簧震动效果0-1
          initialSpringVelocity:2//动画初始速度
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         [_pickerView setFrame:CGRectMake(0, VIEWHIGHT, VIEWWIDTH, 201)];
                     }
                     completion:^(BOOL finished){
                     }];
}

- (IBAction)DoneAction:(id)sender {
    btn.hidden=YES;
    [UIView animateWithDuration:1//动画持续时间
                          delay:0.0//动画延迟时间
         usingSpringWithDamping:1//动画类似弹簧震动效果0-1
          initialSpringVelocity:2//动画初始速度
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         [_pickerView setFrame:CGRectMake(0, VIEWHIGHT, VIEWWIDTH, 201)];
                     }
                     completion:^(BOOL finished){
                     }];
}

- (IBAction)sureClick:(id)sender {
    if (_info!=nil) {
        _info.Address_name=_tfName.text;
        _info.Address_phone=_tfPhone.text;
        
        //当没做修改时，给他赋为初始值
        if ([_lbArea.text isEqualToString:[NSString stringWithFormat:@"%@%@%@",_info.Address_province,_info.Address_city,_info.Address_district]]) {
            selectProvince=[_provinceArray objectAtIndex:provinceIndex];
            selectCity=[_cityArray objectAtIndex:cityIndex];
            selectCounty=[_countyArray objectAtIndex:infoIndex1.county];
        }
       
        
        
        NSLog(@"---%@,%@%@",selectProvince,selectCity,selectCounty);
        
        
        _info.Address_province=selectProvince;
        _info.Address_street=_tfAddress.text;
        _info.Address_userid=loginUserInfo.user_id;
        
        if (_info.AddressIsdefault) {
              _info.AddressIsdefault=YES;
        }else{
        _info.AddressIsdefault=NO;
        }
      
        _info.Address_city=selectCity;
        _info.Address_district=selectCounty;
        _info.province=provinceIndex;
        _info.city=cityIndex;
        _info.county=countyIndex;
        if ([[DBAddress sharedInfo] changeAddressInfo:_info]) {
            
//            AddressInfo *index=[AddressInfo new];
//            index.province=provinceIndex;
//            index.city=cityIndex;
//            index.county=countyIndex;
            
//            if ([[DBAddress sharedInfo] updateAddressIndex:index AddressIndex:_info.Address_id]) {
                [[Toast sharedToastInfo] hideTime:1 makeText:@"修改成功"];
//            }
            
            
        }
    }else {
        if ([_tfName.text isEqualToString:@""]) {
            [[Toast sharedToastInfo] hideTime:1 makeText:@"请输入收货人姓名"];
        }else if ([_tfPhone.text isEqualToString:@""]){
              [[Toast sharedToastInfo] hideTime:1 makeText:@"请输入收货人手机"];
        }else if ([_lbArea.text isEqualToString:@""]){
            [[Toast sharedToastInfo] hideTime:1 makeText:@"请输入所在地区"];
        }else if ([_tfAddress.text isEqualToString:@""]){
            [[Toast sharedToastInfo] hideTime:1 makeText:@"请输入地址"];
        }else{
            
        AddressInfo *info=[[AddressInfo alloc] init];
        info.Address_name=_tfName.text;
        info.Address_phone=_tfPhone.text;
        info.Address_province=selectProvince;
        info.Address_city=selectCity;
        info.Address_district=selectCounty;
        info.Address_street=_tfAddress.text;
        info.AddressIsdefault=NO;
        info.Address_userid=loginUserInfo.user_id;
        info.province=provinceIndex;
        info.city=cityIndex;
        info.county=countyIndex;
            
        if ([[DBAddress sharedInfo] insertInfo:info]) {
           
            [[Toast sharedToastInfo] hideTime:1 makeText:@"添加成功"];
            
         
        }
        }
    }
    
}
@end
