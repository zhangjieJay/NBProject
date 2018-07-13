//
//  NBContactsViewController.m
//  NBProject
//
//  Created by 张杰 on 2018/4/13.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "NBContactsViewController.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>




@interface NBContactsViewController ()<CNContactPickerDelegate>
@property(nonatomic,strong)CNContactStore * cStore;
@property(nonatomic,strong)CNContactFetchRequest * cRequest;

@property(nonatomic,strong)CNSaveRequest * saveRequest;

@end

@implementation NBContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self checkAuthorizationStatus];
}

-(CNContactStore *)cStore{
    if (!_cStore) {
        _cStore = [CNContactStore new];
    }
    return _cStore;
}


-(CNContactFetchRequest *)cRequest{
//    CONTACTS_EXTERN NSString * const CNContactNamePrefixKey                      NS_AVAILABLE(10_11, 9_0);
//    CONTACTS_EXTERN NSString * const CNContactGivenNameKey                       NS_AVAILABLE(10_11, 9_0);
//    CONTACTS_EXTERN NSString * const CNContactMiddleNameKey                      NS_AVAILABLE(10_11, 9_0);
//    CONTACTS_EXTERN NSString * const CNContactFamilyNameKey                      NS_AVAILABLE(10_11, 9_0);
//    CONTACTS_EXTERN NSString * const CNContactPreviousFamilyNameKey              NS_AVAILABLE(10_11, 9_0);
//    CONTACTS_EXTERN NSString * const CNContactNameSuffixKey                      NS_AVAILABLE(10_11, 9_0);
//    CONTACTS_EXTERN NSString * const CNContactNicknameKey                        NS_AVAILABLE(10_11, 9_0);
//    CONTACTS_EXTERN NSString * const CNContactOrganizationNameKey                NS_AVAILABLE(10_11, 9_0);
//    CONTACTS_EXTERN NSString * const CNContactDepartmentNameKey                  NS_AVAILABLE(10_11, 9_0);
//    CONTACTS_EXTERN NSString * const CNContactJobTitleKey                        NS_AVAILABLE(10_11, 9_0);
//    CONTACTS_EXTERN NSString * const CNContactPhoneticGivenNameKey               NS_AVAILABLE(10_11, 9_0);
//    CONTACTS_EXTERN NSString * const CNContactPhoneticMiddleNameKey              NS_AVAILABLE(10_11, 9_0);
//    CONTACTS_EXTERN NSString * const CNContactPhoneticFamilyNameKey              NS_AVAILABLE(10_11, 9_0);
//    CONTACTS_EXTERN NSString * const CNContactPhoneticOrganizationNameKey        NS_AVAILABLE(10_12, 10_0);
//    CONTACTS_EXTERN NSString * const CNContactBirthdayKey                        NS_AVAILABLE(10_11, 9_0);
//    CONTACTS_EXTERN NSString * const CNContactNonGregorianBirthdayKey            NS_AVAILABLE(10_11, 9_0);
//    CONTACTS_EXTERN NSString * const CNContactNoteKey                            NS_AVAILABLE(10_11, 9_0);
//    CONTACTS_EXTERN NSString * const CNContactImageDataKey                       NS_AVAILABLE(10_11, 9_0);
//    CONTACTS_EXTERN NSString * const CNContactThumbnailImageDataKey              NS_AVAILABLE(10_11, 9_0);
//    CONTACTS_EXTERN NSString * const CNContactImageDataAvailableKey              NS_AVAILABLE(10_12, 9_0);
//    CONTACTS_EXTERN NSString * const CNContactTypeKey                            NS_AVAILABLE(10_11, 9_0);
//    CONTACTS_EXTERN NSString * const CNContactPhoneNumbersKey                    NS_AVAILABLE(10_11, 9_0);
//    CONTACTS_EXTERN NSString * const CNContactEmailAddressesKey                  NS_AVAILABLE(10_11, 9_0);
//    CONTACTS_EXTERN NSString * const CNContactPostalAddressesKey                 NS_AVAILABLE(10_11, 9_0);
//    CONTACTS_EXTERN NSString * const CNContactDatesKey                           NS_AVAILABLE(10_11, 9_0);
//    CONTACTS_EXTERN NSString * const CNContactUrlAddressesKey                    NS_AVAILABLE(10_11, 9_0);
//    CONTACTS_EXTERN NSString * const CNContactRelationsKey                       NS_AVAILABLE(10_11, 9_0);
//    CONTACTS_EXTERN NSString * const CNContactSocialProfilesKey                  NS_AVAILABLE(10_11, 9_0);
//    CONTACTS_EXTERN NSString * const CNContactInstantMessageAddressesKey         NS_AVAILABLE(10_11, 9_0);
    if (!_cRequest) {
        
        _cRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:@[CNContactFamilyNameKey,CNContactGivenNameKey,CNContactPhoneNumbersKey]];
        
    }
    return _cRequest;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/**
 *  检测权限并作响应的操作
 */
- (void)checkAuthorizationStatus{
    
    //这里有一个枚举类:CNEntityType,不过没关系，只有一个值:CNEntityTypeContacts
    switch ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts])
    {
            //存在权限
        case CNAuthorizationStatusAuthorized:{
            //获取通讯录
            CNContactPickerViewController * picker = [CNContactPickerViewController new];
            picker.delegate = self;
            [self presentViewController:picker animated:YES completion:nil];
            
            
            
//            [self.cStore enumerateContactsWithFetchRequest:self.cRequest error:nil usingBlock:^(CNContact * contact, BOOL * stop) {
//
//                if ([contact isKeyAvailable:CNContactPhoneNumbersKey]) {
//                    NSArray * phones = contact.phoneNumbers;
//                    for (CNLabeledValue * value in phones) {
//                        NSString * number = ((CNPhoneNumber *)value.value).stringValue;
//                        NSLog(@"姓名:%@%@ 电话号码:%@",contact.familyName,contact.givenName,number);
//
//                    }
//
//
//                }
//            }];
        }
            break;
            
            //权限未知
        case CNAuthorizationStatusNotDetermined:
            //请求权限
            [self.cStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * error) {
                if (granted) {
                    
                }else{
                    
                    
                    
                }
            }];
            break;
            
            //如果没有权限
        case CNAuthorizationStatusRestricted:
        case CNAuthorizationStatusDenied://需要提示
            NSLog(@"拒绝");
            break;
    }
}
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact{
    
    
    
}
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty{
    
    
}

- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker{
    
    
}
@end
