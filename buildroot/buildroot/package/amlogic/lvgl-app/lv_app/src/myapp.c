/*
 * Copyright (C) 2021 Amlogic, Inc. All rights reserved.
 *
 * All information contained herein is Amlogic confidential.
 *
 * This software is provided to you pursuant to Software License Agreement
 * (SLA) with Amlogic Inc ("Amlogic"). This software may be used
 * only in accordance with the terms of this agreement.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification is strictly prohibited without prior written permission from
 * Amlogic.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
#include <lvgl.h>

static void event_cb(lv_event_t *event)
{
    static int cnt = 1;
    lv_obj_t *btn = lv_event_get_target(event);
    lv_obj_t *label = lv_obj_get_child(btn, 0);
    lv_label_set_text_fmt(label, "%d", cnt);
    cnt++;
}

void myapp()
{
    lv_obj_t *btn1 = lv_btn_create(lv_scr_act());
    lv_obj_set_size(btn1, 100, 50);
    lv_obj_center(btn1);
    lv_obj_add_event_cb(btn1, event_cb, LV_EVENT_CLICKED, NULL);
    lv_obj_t * label1 = lv_label_create(btn1);
    lv_label_set_text(label1, "click me!");
    lv_obj_center(label1);
}