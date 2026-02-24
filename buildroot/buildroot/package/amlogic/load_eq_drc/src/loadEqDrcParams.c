/*
 * Copyright (C) 2018 Amlogic Corporation.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#include <stdio.h>
#include <stdint.h>
#include <dirent.h>
#include <sys/types.h>
#include <errno.h>
#include <inttypes.h>
#include <sys/time.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdbool.h>
#include <string.h>
#include <dlfcn.h>
#include <string.h>
#include <unistd.h>

#include "audio_eq_drc.h"

#define LOG_TAG "EQ_DRC_LOAD"

#define LOGD(fmt, args...)    printf("%s " fmt "\n", LOG_TAG,  ##args)
#define LOGE(fmt, args...)    printf("%s " fmt "\n", LOG_TAG,  ##args)

#define READ_BUFFER_SIZE     (512)
#define CFGFILE_PATH_LEN     (128)


#define ALSASOUND_CARD_PATH  "/proc/asound/cards"
#define ALSASOUND_PCM_PATH   "/proc/asound/pcm"

/* sound card name */
#define CARD_NAME_AUGE       "AMLAUGESOUND"
#define CARD_NAME_MESON      "AMLMESONAUDIO"
#define CARD_NAME_M8         "AMLM8AUDIO"
#define CARD_NAME_TV         "AMLTVAUDIO"

#define LIBEQ_DRC_PATH       "/usr/lib/libaudio_effects.so"

//#define EQ_DRC_EFFECTS_DEFAULT_PATH "/etc/eq_drc_effects.ini"

/*
 * cat /proc/asound/cards
 *	 0 [AMLAUGESOUND   ]: AML-AUGESOUND - AML-AUGESOUND
                  AML-AUGESOUND
 * mCardIndex = 0;
 */
static int _alsa_device_get_card_index()
{
    FILE *mCardFile = NULL;
    bool isCardIndexFound = false;
    int mCardIndex = -1;

    mCardFile = fopen(ALSASOUND_CARD_PATH, "r");
    if (mCardFile) {
        char tempbuffer[READ_BUFFER_SIZE];

        while (!feof(mCardFile)) {
            fgets(tempbuffer, READ_BUFFER_SIZE, mCardFile);

            /* this line contain '[' character */
            if (strchr(tempbuffer, '[')) {
                char *Rch = strtok(tempbuffer, "[");
                mCardIndex = atoi(Rch);
                LOGD("\tcurrent mCardIndex = %d, Rch = %s\n", mCardIndex, Rch);
                Rch = strtok(NULL, " ]");
                LOGD("\tcurrent sound card name = %s\n", Rch);
                if (strcmp(Rch, CARD_NAME_AUGE) == 0) {
                    LOGD("\t auge sound cardIndex found = %d\n", mCardIndex);
                    isCardIndexFound = true;
                    break;
                } else {
                    LOGD("\t meson sound cardIndex found = %d\n", mCardIndex);
                    isCardIndexFound = true;
                    break;
                }
            }

            memset((void *)tempbuffer, 0, READ_BUFFER_SIZE);
        }
        fclose(mCardFile);
    } else
        LOGD("Pcm open fail errno %d\n", errno);

    if (isCardIndexFound != true)
        LOGD("ParseCardIndex doesn't found card index\n");

    LOGD("%s() parse card index:%d\n", __FUNCTION__, mCardIndex);

    return mCardIndex;
}


int main(int arc,const char* argv[])
{
    void* handle = NULL;
    const char *errmsg;
    int (*func)(struct eq_drc_data *,char*,char*);
    char aml_cfgfile[CFGFILE_PATH_LEN] = {0};
    char ext_cfgfile[CFGFILE_PATH_LEN] = {0};
    struct eq_drc_data eq_data;

    memset(&eq_data,0,sizeof(struct eq_drc_data));

    if (arc < 2 || (strlen(argv[1]) == 0)) {
        LOGD("Usage: \n\tload_eq_drc <aml_cfgfile> [ext_cfgfile]\n");
    }else {
        strncpy(aml_cfgfile,argv[1],sizeof(aml_cfgfile));

        if ((access(argv[2],F_OK)) == 0) {
            strncpy(ext_cfgfile,argv[2],sizeof(ext_cfgfile));
        }
        LOGD("aml_cfgfile: %s\n.ext_cfgfile: %s\n",argv[1],argv[2]);
    }

    handle = dlopen(LIBEQ_DRC_PATH, RTLD_NOW);
    if (handle == NULL) {
        fprintf(stderr, "Failed to load %s: %s\n",LIBEQ_DRC_PATH, dlerror());
        return 1;
    }

    func = (int (*)(struct eq_drc_data *,char*,char*))dlsym(handle,"eq_drc_init");
    if ((errmsg = dlerror()) != NULL) {
        LOGE("%s\n", errmsg);
        return 1;
    }

    eq_data.card = _alsa_device_get_card_index();

    func(&eq_data,aml_cfgfile,ext_cfgfile);
    return 0;
}

