/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

#include "xsi.h"

struct XSI_INFO xsi_info;



int main(int argc, char **argv)
{
    xsi_init_design(argc, argv);
    xsi_register_info(&xsi_info);

    xsi_register_min_prec_unit(-12);
    unisims_ver_m_00000000002717766859_0437141990_init();
    unisims_ver_m_00000000002717766859_3171644712_init();
    unisims_ver_m_00000000002717766859_0549465058_init();
    unisims_ver_m_00000000002717766859_0883302081_init();
    unisims_ver_m_00000000002717766859_2739786992_init();
    unisims_ver_m_00000000002717766859_2575548148_init();
    work_m_00000000000508270084_3319667384_init();
    work_m_00000000001050340221_1860683421_init();
    work_m_00000000004134447467_2073120511_init();


    xsi_register_tops("work_m_00000000001050340221_1860683421");
    xsi_register_tops("work_m_00000000004134447467_2073120511");


    return xsi_run_simulation(argc, argv);

}
