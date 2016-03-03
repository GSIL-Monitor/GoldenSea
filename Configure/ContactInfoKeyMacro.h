//
//  ContactInfoKeyMacro.h
//  iRCS
//
//  Created by TigerLee on 15/9/9.
//  Copyright (c) 2015年 frank weng. All rights reserved.
//

#ifndef iRCS_ContactInfoKeyMacro_h
#define iRCS_ContactInfoKeyMacro_h

// key array for contact information, onece you add a key for contact information, please add it into this key array first
#define ContactInfoKeyArray @[ADKRecordID, ADKHeadImage, ADKHeadColor, ADKHasImage, ADKFirstName, ADKLastName, ADKFullName, ADKMidName, ADKNameType, ADKJob, ADKCompany, ADKPhoneLabels, ADKPhoneNums, ADKEmailLabels, ADKEmailValues, ADKURLLabels, ADKURLValues, ADKAddressLabels, ADKAddressValues, ADKBirthday, ADKdateLabels, ADKdateValues, ADKRelateNameLabels, ADKRelateNameValues, ADKSocialLabels, ADKSocialValues, ADKInstnMsgLabels, ADKInstnMsgValues]

#define CNKeyDescriptorArray @[CNContactIdentifierKey, CNContactGivenNameKey, CNContactFamilyNameKey, CNContactOrganizationNameKey, CNContactDepartmentNameKey,CNContactJobTitleKey, CNContactBirthdayKey, CNContactNoteKey, CNContactImageDataKey, CNContactThumbnailImageDataKey, CNContactImageDataAvailableKey, CNContactTypeKey, CNContactPhoneNumbersKey, CNContactEmailAddressesKey, CNContactPostalAddressesKey, CNContactDatesKey, CNContactUrlAddressesKey, CNContactRelationsKey, CNContactSocialProfilesKey, CNContactInstantMessageAddressesKey]

/*
#define CNAllKeysDescriptorArray @[CNContactIdentifierKey, CNContactNamePrefixKey, CNContactGivenNameKey, CNContactMiddleNameKey, CNContactFamilyNameKey, CNContactPreviousFamilyNameKey, CNContactNameSuffixKey, CNContactNicknameKey, CNContactPhoneticGivenNameKey, CNContactPhoneticMiddleNameKey, CNContactPhoneticFamilyNameKey, CNContactOrganizationNameKey, CNContactDepartmentNameKey,CNContactJobTitleKey, CNContactBirthdayKey, CNContactNonGregorianBirthdayKey, CNContactNoteKey, CNContactImageDataKey, CNContactThumbnailImageDataKey, CNContactImageDataAvailableKey, CNContactTypeKey, CNContactPhoneNumbersKey, CNContactEmailAddressesKey, CNContactPostalAddressesKey, CNContactDatesKey, CNContactUrlAddressesKey, CNContactRelationsKey, CNContactSocialProfilesKey, CNContactInstantMessageAddressesKey]
*/
 
// define the key of a personal record.
#define ADKRecordID         @"recordID"
#define ADKHeadImage        @"headImage"
#define ADKHeadColor        @"colorHead"
#define ADKHasImage         @"hasImage"
#define ADKFirstName        @"firstName"
#define ADKLastName         @"lastName"
#define ADKFullName         @"fullName"
#define ADKMidName          @"middleName"
#define ADKNameType         @"nameType"
#define ADKJob              @"job"
#define ADKCompany          @"company"
#define ADKPhoneLabels      @"phoneLabels"
#define ADKPhoneNums        @"phoneNums"
#define ADKEmailLabels      @"emailLabels"
#define ADKEmailValues      @"emailValues"
#define ADKURLLabels        @"URLLabels"
#define ADKURLValues        @"URLValues"
#define ADKAddressLabels    @"addressLabels"
#define ADKAddressValues    @"addressValues"
#define ADKBirthday         @"birthday"
#define ADKdateLabels       @"dateLabels"
#define ADKdateValues       @"dateValues"
#define ADKRelateNameLabels @"relateNameLabels"
#define ADKRelateNameValues @"relateNameValues"
#define ADKSocialLabels     @"socialLabels"
#define ADKSocialValues     @"socialValues"
#define ADKInstnMsgLabels   @"instnMsgLabels"
#define ADKInstnMsgValues   @"instnMsgValues"

#define ADKContactGroupType @"contactGroupType"


// 通讯录TableViewCell （ContactVC、ContactSelectVC）
#define kTableHeaderHeight 45 / 2
#define kNormalCellHeight 55
#define kSearchCellHeight 60

// 联系人选择（ContactSelectVC）
#define GROUP_CHAT_SELECT       @"GroupChatSelect"
#define ADDTO_GROUP_CHAT_SELECT @"AddToGroupChatSelect"
#define FORWARD_MSG_SELECT      @"ForwardMessageSelect"
#define FORWARD_MSG_SELECT_RCS  @"ForwardMessageSelectRCS"
#define SHARE_VCARD_SELECT      @"ShareContactSelect"
#define SAVE_VCARD_SELECT       @"SaveVCardToADBookSelect"
#define NEW_MSG_SELECT          @"NewMessageChatSelect"

// 名片发送
#define ADKCONTACT   @"contact"

// 添加陌生号码
#define ADKStrangeNum        @"StrangeNum"

#endif
