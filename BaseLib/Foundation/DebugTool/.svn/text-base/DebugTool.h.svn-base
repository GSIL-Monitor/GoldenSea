
#ifndef _DEBUGTOOL_H_
#define _DEBUGTOOL_H_

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */
	
//#define DEBUG_FILE
	
#if defined(DEBUG)
#define TRACE(format, ...) print_trace(__FILE__, __LINE__, format, ##__VA_ARGS__)
#define PRINT(format, ...) print_line(format, ##__VA_ARGS__)
#else
#define TRACE(format, ...)
#define PRINT(format, ...)
#endif
	
#if defined(DEBUG_WARNING)
#define WARNING(format, ...) print_warning(__FILE__, __LINE__, format, ##__VA_ARGS__)
#else
#define WARNING(format, ...) 
#endif
	
#define ERROR(format, ...) print_error(__FILE__, __LINE__, format, ##__VA_ARGS__)
	
#if defined(DEBUG_FILE)	
#define START_LOG(file, clear) start_log_file(file, clear)
#define END_LOG() end_log_file()
#else
#define START_LOG(file, clear)
#define END_LOG() 
#endif
	
    // 打印警告
    void print_warning(const char* in_file, unsigned int in_line, const char * in_format, ...);
    // 打印跟踪
    void print_line(const char *in_format, ...);
    void print_trace(const char* in_file, unsigned int in_line, const char * in_format, ...);
    // 打印错误
    void print_error(const char* in_file, unsigned int in_line, const char * in_format, ...);
    
    // 设置Log文件路径	
    void start_log_file(const char *in_file, signed char isNeedClearFirst);	
    // 关闭Log文件
    void end_log_file();
	
#ifdef __cplusplus
}
//#endif /* __cplusplus */

#endif
#endif