#include <linux/init.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include "dsc.h"

struct dsc_config dsc_cfg;
struct dsc_picture_parameter_set pps_payload;

void dsc_pps_payload_pack(struct dsc_picture_parameter_set *pps_payload,
			  const struct dsc_config *dsc_cfg)
{
	int i;

	/* Protect against someone accidently changing struct size */
	if (sizeof(*pps_payload) != DP_SDP_PPS_HEADER_PAYLOAD_BYTES_MINUS_1 + 1)
		pr_info("pps payload size mismatch\n");

	memset(pps_payload, 0, sizeof(*pps_payload));

	/* PPS 0 */
	pps_payload->dsc_version = dsc_cfg->dsc_version_minor |
				   dsc_cfg->dsc_version_major
					   << DSC_PPS_VERSION_MAJOR_SHIFT;

	/* PPS 1, 2 is 0 */

	/* PPS 3 */
	pps_payload->pps_3 = dsc_cfg->line_buf_depth |
			     dsc_cfg->bits_per_component << DSC_PPS_BPC_SHIFT;

	/* PPS 4 */
	pps_payload->pps_4 =
		((dsc_cfg->bits_per_pixel & DSC_PPS_BPP_HIGH_MASK) >>
		 DSC_PPS_MSB_SHIFT) |
		dsc_cfg->vbr_enable << DSC_PPS_VBR_EN_SHIFT |
		dsc_cfg->simple_422 << DSC_PPS_SIMPLE422_SHIFT |
		dsc_cfg->convert_rgb << DSC_PPS_CONVERT_RGB_SHIFT |
		dsc_cfg->block_pred_enable << DSC_PPS_BLOCK_PRED_EN_SHIFT;

	/* PPS 5 */
	pps_payload->bits_per_pixel_low =
		(dsc_cfg->bits_per_pixel & DSC_PPS_LSB_MASK);

	/*
	 * The DSC panel expects the PPS packet to have big endian format
	 * for data spanning 2 bytes. Use a macro cpu_to_be16() to convert
	 * to big endian format. If format is little endian, it will swap
	 * bytes to convert to Big endian else keep it unchanged.
	 */

	/* PPS 6, 7 */
	pps_payload->pic_height = cpu_to_be16(dsc_cfg->pic_height);

	/* PPS 8, 9 */
	pps_payload->pic_width = cpu_to_be16(dsc_cfg->pic_width);

	/* PPS 10, 11 */
	pps_payload->slice_height = cpu_to_be16(dsc_cfg->slice_height);

	/* PPS 12, 13 */
	pps_payload->slice_width = cpu_to_be16(dsc_cfg->slice_width);
	pr_info("pic h:%#x w:%#x, slice h:%#x w:%#x\n", pps_payload->pic_height, pps_payload->pic_width, pps_payload->slice_height, pps_payload->slice_width);
	/* PPS 14, 15 */
	pps_payload->chunk_size = cpu_to_be16(dsc_cfg->slice_chunk_size);

	/* PPS 16 */
	pps_payload->initial_xmit_delay_high =
		((dsc_cfg->initial_xmit_delay &
		  DSC_PPS_INIT_XMIT_DELAY_HIGH_MASK) >>
		 DSC_PPS_MSB_SHIFT);

	/* PPS 17 */
	pps_payload->initial_xmit_delay_low =
		(dsc_cfg->initial_xmit_delay & DSC_PPS_LSB_MASK);

	/* PPS 18, 19 */
	pps_payload->initial_dec_delay =
		cpu_to_be16(dsc_cfg->initial_dec_delay);

	/* PPS 20 is 0 */

	/* PPS 21 */
	pps_payload->initial_scale_value = dsc_cfg->initial_scale_value;

	/* PPS 22, 23 */
	pps_payload->scale_increment_interval =
		cpu_to_be16(dsc_cfg->scale_increment_interval);

	/* PPS 24 */
	pps_payload->scale_decrement_interval_high =
		((dsc_cfg->scale_decrement_interval &
		  DSC_PPS_SCALE_DEC_INT_HIGH_MASK) >>
		 DSC_PPS_MSB_SHIFT);

	/* PPS 25 */
	pps_payload->scale_decrement_interval_low =
		(dsc_cfg->scale_decrement_interval & DSC_PPS_LSB_MASK);

	/* PPS 26[7:0], PPS 27[7:5] RESERVED */

	/* PPS 27 */
	pps_payload->first_line_bpg_offset = dsc_cfg->first_line_bpg_offset;

	/* PPS 28, 29 */
	pps_payload->nfl_bpg_offset = cpu_to_be16(dsc_cfg->nfl_bpg_offset);

	/* PPS 30, 31 */
	pps_payload->slice_bpg_offset = cpu_to_be16(dsc_cfg->slice_bpg_offset);

	/* PPS 32, 33 */
	pps_payload->initial_offset = cpu_to_be16(dsc_cfg->initial_offset);

	/* PPS 34, 35 */
	pps_payload->final_offset = cpu_to_be16(dsc_cfg->final_offset);

	/* PPS 36 */
	pps_payload->flatness_min_qp = dsc_cfg->flatness_min_qp;

	/* PPS 37 */
	pps_payload->flatness_max_qp = dsc_cfg->flatness_max_qp;

	/* PPS 38, 39 */
	pps_payload->rc_model_size = cpu_to_be16(DSC_RC_MODEL_SIZE_CONST);

	/* PPS 40 */
	pps_payload->rc_edge_factor = DSC_RC_EDGE_FACTOR_CONST;

	/* PPS 41 */
	pps_payload->rc_quant_incr_limit0 = dsc_cfg->rc_quant_incr_limit0;

	/* PPS 42 */
	pps_payload->rc_quant_incr_limit1 = dsc_cfg->rc_quant_incr_limit1;

	/* PPS 43 */
	pps_payload->rc_tgt_offset = DSC_RC_TGT_OFFSET_LO_CONST |
				     DSC_RC_TGT_OFFSET_HI_CONST
					     << DSC_PPS_RC_TGT_OFFSET_HI_SHIFT;

	/* PPS 44 - 57 */
	for (i = 0; i < DSC_NUM_BUF_RANGES - 1; i++)
		pps_payload->rc_buf_thresh[i] = dsc_cfg->rc_buf_thresh[i];

	/* PPS 58 - 87 */
	/*
	 * For DSC sink programming the RC Range parameter fields
	 * are as follows: Min_qp[15:11], max_qp[10:6], offset[5:0]
	 */
	for (i = 0; i < DSC_NUM_BUF_RANGES; i++) {
		pps_payload->rc_range_parameters[i] = cpu_to_be16(
			(dsc_cfg->rc_range_params[i].range_min_qp
			 << DSC_PPS_RC_RANGE_MINQP_SHIFT) |
			(dsc_cfg->rc_range_params[i].range_max_qp
			 << DSC_PPS_RC_RANGE_MAXQP_SHIFT) |
			(dsc_cfg->rc_range_params[i].range_bpg_offset));
	}

	/* PPS 88 */
	pps_payload->native_422_420 = dsc_cfg->native_422 |
				      dsc_cfg->native_420
					      << DSC_PPS_NATIVE_420_SHIFT;

	/* PPS 89 */
	pps_payload->second_line_bpg_offset = dsc_cfg->second_line_bpg_offset;

	/* PPS 90, 91 */
	pps_payload->nsl_bpg_offset = cpu_to_be16(dsc_cfg->nsl_bpg_offset);

	/* PPS 92, 93 */
	pps_payload->second_line_offset_adj =
		cpu_to_be16(dsc_cfg->second_line_offset_adj);

	/* PPS 94 - 127 are O */
}
/**
 * RGB24 - 1920x1080
 *       rc_8bpc_8bpp.cfg
 */
/* clang-format off */
static void bst_dsc_cfg_8bpc_8bpp_1920_1080(struct dsc_config *vdsc_cfg)
{
	vdsc_cfg->dsc_version_major        = 1;
	vdsc_cfg->dsc_version_minor        = 2;

	vdsc_cfg->bits_per_component       = 0x8;
	vdsc_cfg->line_buf_depth           = 0xb; // 11
	vdsc_cfg->block_pred_enable        = 1;
	vdsc_cfg->convert_rgb              = true;
	vdsc_cfg->simple_422               = false;
	vdsc_cfg->vbr_enable               = false;
	vdsc_cfg->bits_per_pixel           = 0x080; // 128
	vdsc_cfg->pic_height               = 1080;
	vdsc_cfg->pic_width                = 1920;
	vdsc_cfg->slice_height             = 1080;
	vdsc_cfg->slice_width              = 480;
	vdsc_cfg->slice_chunk_size         = 480;
	vdsc_cfg->initial_xmit_delay       = 512;
	vdsc_cfg->initial_dec_delay        = 496;
	vdsc_cfg->initial_scale_value      = 32;
	vdsc_cfg->scale_increment_interval = 342;
	vdsc_cfg->scale_decrement_interval = 6;
	vdsc_cfg->first_line_bpg_offset    = 12;
	vdsc_cfg->nfl_bpg_offset           = 1756;
	vdsc_cfg->slice_bpg_offset         = 1953;
	vdsc_cfg->initial_offset           = 6144;
	vdsc_cfg->final_offset             = 4336;
	vdsc_cfg->flatness_min_qp          = 3;
	vdsc_cfg->flatness_max_qp          = 12;

	vdsc_cfg->rc_model_size            = 8192;
	vdsc_cfg->rc_edge_factor           = 6;
	vdsc_cfg->rc_quant_incr_limit0     = 11;
	vdsc_cfg->rc_quant_incr_limit1     = 11;
	vdsc_cfg->rc_tgt_offset_high       = 3;
	vdsc_cfg->rc_tgt_offset_low        = 3;

	vdsc_cfg->rc_buf_thresh[0]         = 0x0e; // 14     => 896
	vdsc_cfg->rc_buf_thresh[1]         = 0x1c; // 28     => 1792
	vdsc_cfg->rc_buf_thresh[2]         = 0x2a; // 42     => 2688
	vdsc_cfg->rc_buf_thresh[3]         = 0x38; // 56     => 3584
	vdsc_cfg->rc_buf_thresh[4]         = 0x46; // 70     => 4480
	vdsc_cfg->rc_buf_thresh[5]         = 0x54; // 84     => 5376
	vdsc_cfg->rc_buf_thresh[6]         = 0x62; // 98     => 6272
	vdsc_cfg->rc_buf_thresh[7]         = 0x69; // 105    => 6720
	vdsc_cfg->rc_buf_thresh[8]         = 0x70; // 112    => 7168
	vdsc_cfg->rc_buf_thresh[9]         = 0x77; // 119    => 7616
	vdsc_cfg->rc_buf_thresh[10]        = 0x79; // 121    => 7744
	vdsc_cfg->rc_buf_thresh[11]        = 0x7b; // 123    => 7872
	vdsc_cfg->rc_buf_thresh[12]        = 0x7d; // 125    => 8000
	vdsc_cfg->rc_buf_thresh[13]        = 0x7e; // 126    => 8064
	vdsc_cfg->rc_range_params[0].range_min_qp     = 0x00; // 0
	vdsc_cfg->rc_range_params[0].range_max_qp     = 0x04; // 4
	vdsc_cfg->rc_range_params[0].range_bpg_offset = 0x02; // 2      => 2

	vdsc_cfg->rc_range_params[1].range_min_qp     = 0x00; // 0
	vdsc_cfg->rc_range_params[1].range_max_qp     = 0x04; // 4
	vdsc_cfg->rc_range_params[1].range_bpg_offset = 0x00; // 0      => 0

	vdsc_cfg->rc_range_params[2].range_min_qp     = 0x01; // 1
	vdsc_cfg->rc_range_params[2].range_max_qp     = 0x05; // 5
	vdsc_cfg->rc_range_params[2].range_bpg_offset = 0x00; // 0      => 0

	vdsc_cfg->rc_range_params[3].range_min_qp     = 0x01; // 1
	vdsc_cfg->rc_range_params[3].range_max_qp     = 0x06; // 6
	vdsc_cfg->rc_range_params[3].range_bpg_offset = 0x3e; // 62     => -2

	vdsc_cfg->rc_range_params[4].range_min_qp     = 0x03; // 3
	vdsc_cfg->rc_range_params[4].range_max_qp     = 0x07; // 7
	vdsc_cfg->rc_range_params[4].range_bpg_offset =	0x3c; // 60     => -4

	vdsc_cfg->rc_range_params[5].range_min_qp     = 0x03; // 3
	vdsc_cfg->rc_range_params[5].range_max_qp     = 0x07; // 7
	vdsc_cfg->rc_range_params[5].range_bpg_offset =	0x3a; // 58     => -6

	vdsc_cfg->rc_range_params[6].range_min_qp     = 0x03; // 3
	vdsc_cfg->rc_range_params[6].range_max_qp     = 0x07; // 7
	vdsc_cfg->rc_range_params[6].range_bpg_offset =	0x38; // 56     => -8

	vdsc_cfg->rc_range_params[7].range_min_qp     = 0x03; // 3
	vdsc_cfg->rc_range_params[7].range_max_qp     = 0x08; // 8
	vdsc_cfg->rc_range_params[7].range_bpg_offset =	0x38; // 56     => -8

	vdsc_cfg->rc_range_params[8].range_min_qp     = 0x03; // 3
	vdsc_cfg->rc_range_params[8].range_max_qp     = 0x09; // 9
	vdsc_cfg->rc_range_params[8].range_bpg_offset =	0x38; // 56     => -8

	vdsc_cfg->rc_range_params[9].range_min_qp     = 0x03; // 3
	vdsc_cfg->rc_range_params[9].range_max_qp     = 0x0a; // 10
	vdsc_cfg->rc_range_params[9].range_bpg_offset =	0x36; // 54     => -10

	vdsc_cfg->rc_range_params[10].range_min_qp     = 0x05; // 5
	vdsc_cfg->rc_range_params[10].range_max_qp     = 0x0a; // 10
	vdsc_cfg->rc_range_params[10].range_bpg_offset = 0x36; // 54     => -10

	vdsc_cfg->rc_range_params[11].range_min_qp     = 0x05; // 5
	vdsc_cfg->rc_range_params[11].range_max_qp     = 0x0b; // 11
	vdsc_cfg->rc_range_params[11].range_bpg_offset = 0x34; // 52     => -12

	vdsc_cfg->rc_range_params[12].range_min_qp     = 0x05; // 5
	vdsc_cfg->rc_range_params[12].range_max_qp     = 0x0b; // 11
	vdsc_cfg->rc_range_params[12].range_bpg_offset = 0x34; // 52     => -12

	vdsc_cfg->rc_range_params[13].range_min_qp     = 0x09; // 9
	vdsc_cfg->rc_range_params[13].range_max_qp     = 0x0c; // 12
	vdsc_cfg->rc_range_params[13].range_bpg_offset = 0x34; // 52     => -12

	vdsc_cfg->rc_range_params[14].range_min_qp     = 0x0c; // 12
	vdsc_cfg->rc_range_params[14].range_max_qp     = 0x0d; // 13
	vdsc_cfg->rc_range_params[14].range_bpg_offset = 0x34; // 52     => -12
	vdsc_cfg->native_420             = 0;
	vdsc_cfg->native_422             = 0;
	vdsc_cfg->second_line_bpg_offset = 0;
	vdsc_cfg->nsl_bpg_offset         = 0;
	vdsc_cfg->second_line_offset_adj = 0;
}
/* 3840x2160 */
static void bst_dsc_cfg_10bpc_8bpp_3840_2160(struct dsc_config *vdsc_cfg)
{
	vdsc_cfg->dsc_version_major        = 1;
	vdsc_cfg->dsc_version_minor        = 2;

	vdsc_cfg->bits_per_component       = 10;
	vdsc_cfg->line_buf_depth           = 0xb; // 11
	vdsc_cfg->block_pred_enable        = 1;
	vdsc_cfg->convert_rgb              = true;
	vdsc_cfg->simple_422               = false;
	vdsc_cfg->vbr_enable               = false;
	vdsc_cfg->bits_per_pixel           = 0x080; // 128
	vdsc_cfg->pic_height               = 2160;
	vdsc_cfg->pic_width                = 3840;
	vdsc_cfg->slice_height             = 2160;
	vdsc_cfg->slice_width              = 960;
	vdsc_cfg->slice_chunk_size         = 960;
	vdsc_cfg->initial_xmit_delay       = 512;
	vdsc_cfg->initial_dec_delay        = 736;
	vdsc_cfg->initial_scale_value      = 32;
	vdsc_cfg->scale_increment_interval = 464;
	vdsc_cfg->scale_decrement_interval = 13;
	vdsc_cfg->first_line_bpg_offset    = 12;
	vdsc_cfg->nfl_bpg_offset           = 1756;
	vdsc_cfg->slice_bpg_offset         = 977;
	vdsc_cfg->initial_offset           = 6144;
	vdsc_cfg->final_offset             = 4336;
	vdsc_cfg->flatness_min_qp          = 7;
	vdsc_cfg->flatness_max_qp          = 16;

	vdsc_cfg->rc_model_size            = 8192;
	vdsc_cfg->rc_edge_factor           = 6;
	vdsc_cfg->rc_quant_incr_limit0     = 15;
	vdsc_cfg->rc_quant_incr_limit1     = 15;
	vdsc_cfg->rc_tgt_offset_high       = 3;
	vdsc_cfg->rc_tgt_offset_low        = 3;

	vdsc_cfg->rc_buf_thresh[0]         = 0x0e; // 14     => 896
	vdsc_cfg->rc_buf_thresh[1]         = 0x1c; // 28     => 1792
	vdsc_cfg->rc_buf_thresh[2]         = 0x2a; // 42     => 2688
	vdsc_cfg->rc_buf_thresh[3]         = 0x38; // 56     => 3584
	vdsc_cfg->rc_buf_thresh[4]         = 0x46; // 70     => 4480
	vdsc_cfg->rc_buf_thresh[5]         = 0x54; // 84     => 5376
	vdsc_cfg->rc_buf_thresh[6]         = 0x62; // 98     => 6272
	vdsc_cfg->rc_buf_thresh[7]         = 0x69; // 105    => 6720
	vdsc_cfg->rc_buf_thresh[8]         = 0x70; // 112    => 7168
	vdsc_cfg->rc_buf_thresh[9]         = 0x77; // 119    => 7616
	vdsc_cfg->rc_buf_thresh[10]        = 0x79; // 121    => 7744
	vdsc_cfg->rc_buf_thresh[11]        = 0x7b; // 123    => 7872
	vdsc_cfg->rc_buf_thresh[12]        = 0x7d; // 125    => 8000
	vdsc_cfg->rc_buf_thresh[13]        = 0x7e; // 126    => 8064
	vdsc_cfg->rc_range_params[0].range_min_qp     = 0x00; // 0
	vdsc_cfg->rc_range_params[0].range_max_qp     = 0x04; // 4
	vdsc_cfg->rc_range_params[0].range_bpg_offset = 0x02; // 2      => 2

	vdsc_cfg->rc_range_params[1].range_min_qp     = 0x00; // 0
	vdsc_cfg->rc_range_params[1].range_max_qp     = 0x04; // 4
	vdsc_cfg->rc_range_params[1].range_bpg_offset = 0x00; // 0      => 0

	vdsc_cfg->rc_range_params[2].range_min_qp     = 0x01; // 1
	vdsc_cfg->rc_range_params[2].range_max_qp     = 0x05; // 5
	vdsc_cfg->rc_range_params[2].range_bpg_offset = 0x00; // 0      => 0

	vdsc_cfg->rc_range_params[3].range_min_qp     = 0x01; // 1
	vdsc_cfg->rc_range_params[3].range_max_qp     = 0x06; // 6
	vdsc_cfg->rc_range_params[3].range_bpg_offset = 0x3e; // 62     => -2

	vdsc_cfg->rc_range_params[4].range_min_qp     = 0x03; // 3
	vdsc_cfg->rc_range_params[4].range_max_qp     = 0x07; // 7
	vdsc_cfg->rc_range_params[4].range_bpg_offset =	0x3c; // 60     => -4

	vdsc_cfg->rc_range_params[5].range_min_qp     = 0x03; // 3
	vdsc_cfg->rc_range_params[5].range_max_qp     = 0x07; // 7
	vdsc_cfg->rc_range_params[5].range_bpg_offset =	0x3a; // 58     => -6

	vdsc_cfg->rc_range_params[6].range_min_qp     = 0x03; // 3
	vdsc_cfg->rc_range_params[6].range_max_qp     = 0x07; // 7
	vdsc_cfg->rc_range_params[6].range_bpg_offset =	0x38; // 56     => -8

	vdsc_cfg->rc_range_params[7].range_min_qp     = 0x03; // 3
	vdsc_cfg->rc_range_params[7].range_max_qp     = 0x08; // 8
	vdsc_cfg->rc_range_params[7].range_bpg_offset =	0x38; // 56     => -8

	vdsc_cfg->rc_range_params[8].range_min_qp     = 0x03; // 3
	vdsc_cfg->rc_range_params[8].range_max_qp     = 0x09; // 9
	vdsc_cfg->rc_range_params[8].range_bpg_offset =	0x38; // 56     => -8

	vdsc_cfg->rc_range_params[9].range_min_qp     = 0x03; // 3
	vdsc_cfg->rc_range_params[9].range_max_qp     = 0x0a; // 10
	vdsc_cfg->rc_range_params[9].range_bpg_offset =	0x36; // 54     => -10

	vdsc_cfg->rc_range_params[10].range_min_qp     = 0x05; // 5
	vdsc_cfg->rc_range_params[10].range_max_qp     = 0x0a; // 10
	vdsc_cfg->rc_range_params[10].range_bpg_offset = 0x36; // 54     => -10

	vdsc_cfg->rc_range_params[11].range_min_qp     = 0x05; // 5
	vdsc_cfg->rc_range_params[11].range_max_qp     = 0x0b; // 11
	vdsc_cfg->rc_range_params[11].range_bpg_offset = 0x34; // 52     => -12

	vdsc_cfg->rc_range_params[12].range_min_qp     = 0x05; // 5
	vdsc_cfg->rc_range_params[12].range_max_qp     = 0x0b; // 11
	vdsc_cfg->rc_range_params[12].range_bpg_offset = 0x34; // 52     => -12

	vdsc_cfg->rc_range_params[13].range_min_qp     = 0x09; // 9
	vdsc_cfg->rc_range_params[13].range_max_qp     = 0x0c; // 12
	vdsc_cfg->rc_range_params[13].range_bpg_offset = 0x34; // 52     => -12

	vdsc_cfg->rc_range_params[14].range_min_qp     = 0x0c; // 12
	vdsc_cfg->rc_range_params[14].range_max_qp     = 0x0d; // 13
	vdsc_cfg->rc_range_params[14].range_bpg_offset = 0x34; // 52     => -12
	vdsc_cfg->native_420             = 0;
	vdsc_cfg->native_422             = 0;
	vdsc_cfg->second_line_bpg_offset = 0;
	vdsc_cfg->nsl_bpg_offset         = 0;
	vdsc_cfg->second_line_offset_adj = 0;
}


void dump_pps(struct dsc_picture_parameter_set *pps_payload) {
    u32 *pps = (u32 *)pps_payload;
    u32 count = 0;

    for (;count <sizeof(*pps)/sizeof(u32);count++) {
        pr_info("pps[%d] = %#x\n", pps[count]);
    }
}

void dsc2pps(void) {
    memset(&dsc_cfg, 0, sizeof(struct dsc_config));
    memset(&pps_payload, 0, sizeof(pps_payload));
    bst_dsc_cfg_8bpc_8bpp_1920_1080(&dsc_cfg);
    dsc_pps_payload_pack(&pps_payload, &dsc_cfg);
    dump_pps(&pps_payload);


    memset(&dsc_cfg, 0, sizeof(struct dsc_config));
    memset(&pps_payload, 0, sizeof(pps_payload));
    bst_dsc_cfg_10bpc_8bpp_3840_2160(&dsc_cfg);
    dsc_pps_payload_pack(&pps_payload, &dsc_cfg);
    dump_pps(&pps_payload);

}

static int __init dsc2pps_test_init(void)
{

    pr_info("[%s:%d]\n", __func__, __LINE__);
    dsc2pps();
	return 0;
}

static void __exit dsc2pps_test_exit(void)
{
	pr_info("[%s:%d]\n", __func__, __LINE__);
}

module_init(dsc2pps_test_init);
module_exit(dsc2pps_test_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("robin.jiang <jiangrenbin329@gmail.com>");
MODULE_DESCRIPTION("Kernel api test");