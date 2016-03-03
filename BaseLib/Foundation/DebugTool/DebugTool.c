

#include "DebugTool.h"
#include <stdarg.h>
#include <stddef.h>
#include <assert.h>
#include <string.h>
#include <stdio.h>
#include <time.h>
#include <unistd.h>

#if defined(DEBUG_FILE)
static FILE *_logFile = NULL;
#endif

void print_internal(const char * header, const char* in_file, unsigned int in_line, const char * in_format, va_list arg_list);

int get_last_path_component(char *in_file, char *out_buffer, unsigned int in_bufferSize);

void end_log_file()
{
#if defined(DEBUG_FILE)
	if (_logFile) {
		char timeStr[20] = {0};
		time_t t = time(NULL);
		struct tm *stTm = localtime(&t);
		snprintf(timeStr, 20, "%04d-%02d-%02d %02d:%02d:%02d"
				 , stTm->tm_year + 1900, stTm->tm_mon + 1, stTm->tm_mday
				 , stTm->tm_hour, stTm->tm_min, stTm->tm_sec);
		fprintf(_logFile, "**********  END LOG ON %s  **********\n", timeStr);
		fflush(_logFile);
		fclose(_logFile);
		_logFile = NULL;
	}
#endif
}

void start_log_file(const char *in_file, signed char isNeedClearFirst)
{
	end_log_file();
#if defined(DEBUG_FILE)
	if (isNeedClearFirst) 
		_logFile = fopen(in_file, "w+");
	else
		_logFile = fopen(in_file, "a+");
	if (_logFile) {
		char timeStr[20] = {0};
		time_t t = time(NULL);
		struct tm *stTm = localtime(&t);
		snprintf(timeStr, 20, "%04d-%02d-%02d %02d:%02d:%02d"
				 , stTm->tm_year + 1900, stTm->tm_mon + 1, stTm->tm_mday
				 , stTm->tm_hour, stTm->tm_min, stTm->tm_sec);
		fprintf(_logFile, "********** BEGIN LOG ON %s **********\n", timeStr);
		fflush(_logFile);
	}
#endif
}

// 返回文件路径最后的文件名字
int get_last_path_component(char *in_file, char *out_buffer, unsigned int in_bufferSize)
{
	int str_len = 0;
	int last_component_len = 0;
	if (!in_file) return 0;
	
	str_len = (int)strlen(in_file);
	in_file += str_len;
	while (last_component_len < str_len) {
		-- in_file;
		if (*in_file == '/') {
			break;
		}
		++ last_component_len;
	}
	if (last_component_len != 0) {
		if ((last_component_len + 1) < in_bufferSize) {
			strncpy(out_buffer, ++ in_file, last_component_len);
			out_buffer[last_component_len] = '\0';
		} else {
			strncpy(out_buffer, ++ in_file, in_bufferSize);
			out_buffer[in_bufferSize - 1] = '\0';
		}
	}
	return last_component_len;
}

void print_line(const char *in_format, ...)
{
	va_list arg_list;
	va_start(arg_list, in_format);
	
#if defined(DEBUG_FILE)
	if (_logFile){
		vfprintf(_logFile, in_format, arg_list);
		fprintf(_logFile, "\n");
		fflush(_logFile);
	}
#else
	vprintf(in_format, arg_list);
	printf("\n");
#endif
	va_end(arg_list);
}

void print_internal(const char * header, const char* in_file, unsigned int in_line, const char * in_format, va_list arg_list)
{
	static char file_name[64];
	char * file_path;
	file_path = (char *)in_file;
	
#if defined(DEBUG_FILE)
	if (_logFile) {
		fprintf(_logFile, "%s", header);
		if (get_last_path_component(file_path, file_name, sizeof(file_name)) > 0) {
			fprintf(_logFile, "%s:%d ", file_name, in_line);
		}
		vfprintf(_logFile, in_format, arg_list);
		fprintf(_logFile, "\n");
		fflush(_logFile);
	}
#else
	printf("%s", header);
	if (get_last_path_component(file_path, file_name, sizeof(file_name)) > 0) {
		printf("%s:%d ", file_name, in_line);
	}
	vprintf(in_format, arg_list);
	printf("\n"); 
#endif
}

void print_trace(const char* in_file, unsigned int in_line, const char * in_format, ...)
{
	assert(in_format);
	va_list arg_list;
	va_start(arg_list, in_format);
	print_internal("**[Trace]** ", in_file, in_line, in_format, arg_list);
	va_end(arg_list);
}

void print_warning(const char* in_file, unsigned int in_line, const char * in_format, ...)
{
	assert(in_format);
	va_list arg_list;
	va_start(arg_list, in_format);
	print_internal("**[Warning]** ", in_file, in_line, in_format, arg_list);
	va_end(arg_list);
}

void print_error(const char* in_file, unsigned int in_line, const char * in_format, ...)
{
	assert(in_format);
	va_list arg_list;
	va_start(arg_list, in_format);
	print_internal("**[Error]** ", in_file, in_line, in_format, arg_list);
	va_end(arg_list);
}






