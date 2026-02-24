/* SPDX-License-Identifier: (MIT) */
#include "lvgl/lvgl.h"
#include "lv_drivers/display/fbdev.h"

#include <unistd.h>
#include <pthread.h>
#include <time.h>
#include <sys/time.h>
#include "lv_drivers/indev/evdev.h"


#define SCREEN_WIDTH 720
#define SCREEN_HEIGHT 720
#define DISP_BUF_SIZE (4*SCREEN_WIDTH*SCREEN_HEIGHT)

extern void lv_demo_widgets(void);
extern void myapp();

uint32_t custom_tick_get(void)
{
    static uint64_t start_ms = 0;
    if (start_ms == 0)
    {
        struct timeval tv_start;
        gettimeofday(&tv_start, NULL);
        start_ms = (tv_start.tv_sec * 1000000 + tv_start.tv_usec) / 1000;
    }

    struct timeval tv_now;
    gettimeofday(&tv_now, NULL);
    uint64_t now_ms;
    now_ms = (tv_now.tv_sec * 1000000 + tv_now.tv_usec) / 1000;

    uint32_t time_ms = now_ms - start_ms;
    return time_ms;
}

int main(void)
{
    /*LittlevGL init*/
    lv_init();

    /*Linux frame buffer device init*/
    fbdev_init();

    /*A small buffer for LittlevGL to draw the screen's content*/
    static lv_color_t buf[DISP_BUF_SIZE];

    /*Initialize a descriptor for the buffer*/
    static lv_disp_draw_buf_t disp_buf;
    lv_disp_draw_buf_init(&disp_buf, buf, NULL, DISP_BUF_SIZE);

    /*Initialize and register a display driver*/
    static lv_disp_drv_t disp_drv;
    lv_disp_drv_init(&disp_drv);
    disp_drv.draw_buf = &disp_buf;
    disp_drv.flush_cb = fbdev_flush;
    disp_drv.hor_res = SCREEN_WIDTH;
    disp_drv.ver_res = SCREEN_HEIGHT;
    lv_disp_drv_register(&disp_drv);

    evdev_init();
    lv_indev_drv_t indev_drv;
    lv_indev_drv_init(&indev_drv);
    indev_drv.type = LV_INDEV_TYPE_POINTER;
    indev_drv.read_cb = evdev_read;
    lv_indev_drv_register(&indev_drv);

/*Create a Demo*/
#ifdef ENABLE_LVGL_DEMOS
    lv_demo_widgets();
#else
    myapp();
#endif
    // lv_demo_music();
    // lv_demo_stress();
    // lv_demo_benchmark();
    // lv_demo_printer();
    // lv_demo_keypad_encoder();

    /*Handle LitlevGL tasks (tickless mode)*/

    while (1)
    {
        lv_task_handler();
        usleep(5000);
    }

    return 0;
}
