//
//  HYAvailability.h.h
//

#ifndef _Client_iOS_Common_HYAvailability_h
#define _Client_iOS_Common_HYAvailability_h

//API使用中
#define HY_API_STABLE __attribute__ ((visibility("default")))

//API开发中
#define HY_API_EVOLVING __attribute__ ((visibility("internal")))

//API废弃
#define HY_API_DEPRECATED __attribute__((deprecated))

#endif
