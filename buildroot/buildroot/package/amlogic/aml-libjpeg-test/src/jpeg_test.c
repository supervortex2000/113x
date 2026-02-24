#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include "jpeg_interface.h"

static const char *input_file = NULL;
static struct resolution {
  int width;
  int height;
} res;

static int get_time_msec() {
  struct timeval tv;
  gettimeofday(&tv, NULL);
  return tv.tv_sec * 1000 + tv.tv_usec / 1000;
}

static void print_usage(char **argv) {
  printf("USAGE:%s \n"
         "  -h: show this help\n"
         "  -s: size(WxH, e.g. 1920x1080)\n"
         "  -f: filepath(e.g. /data/xxxx.yuv)\n",
         argv[0]);
}

int main(int argc, char **argv)
{
  if (argc <= 1) {
    print_usage(argv);
    return -1;
  }

  int ret;

  int opt;
  while ((opt = getopt(argc, (char **)argv, "s:f:h")) != -1) {
    switch (opt) {
      case 's':
        if (sscanf(optarg, "%dx%d", &res.width, &res.height) != 2) {
          printf("wrong image size: %s\n", optarg);
          return -1;
        }
        break;
      case 'f':
        input_file = optarg;
        if (!input_file) {
          printf("error: filepath is a nullptr\n");
          return -1;
        }
        break;
      case 'h':
        print_usage(argv);
        return 0;
      default:
        printf("invaild option '%c'\n", opt);
        print_usage(argv);
        return -1;
    }
  }

  /* compression test (YUV) */
  FILE *fp_input;
  int len = res.width * res.height * 3 / 2;
  char *output_jpegfile = "/data/output_file.jpg";
  if ((fp_input = fopen(input_file, "rb")) == NULL) {
    fprintf(stderr, "can't open %s: %s\n", input_file, strerror(errno));
    return -1;
  }

  unsigned char *in_buf = (unsigned char *)malloc(len);
  fread(in_buf, 1, len, fp_input);

  enum JColorSpace color_space = JColorSpaceYCbCr;
  int comp_start, comp_end;
  comp_start = get_time_msec();
  compress_to_jpeg_file(color_space, output_jpegfile,
          90, in_buf, res.width, res.height);
  comp_end = get_time_msec();
  printf("[ compression time interval ] : %dms\n", comp_end - comp_start);

  /* decompression test */
  char* input_jpeg_filename = output_jpegfile;
  int decomp_start, decomp_end;
  decomp_start = get_time_msec();
  ret = decompress_from_jpeg_file(input_jpeg_filename);
  decomp_end = get_time_msec();
  printf("[ decompression time interval ] : %dms\n", decomp_end - decomp_start);

  return 0;
}
