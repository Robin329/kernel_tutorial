#include <linux/bitops.h>
#include <linux/module.h>

#undef pr_fmt
#define pr_fmt(fmt) KBUILD_MODNAME "  [%s:%d] " fmt, __func__, __LINE__


// =========================================================================

struct fw_msg_data {
	uint32_t guest_magic;
	uint32_t subdev_session;
	uint32_t cmdset;
	uint32_t cmdid;
	uint32_t size_cmd;
	uint32_t size_ack;
	uint32_t user_cmd_data[32 / 4];
	uint32_t user_ack_data[42 / 4];
	uint32_t sync_mode;
};

// user defined types
struct _display_Array_Uint8_t {
	uint8_t *data;
	uint32_t size;
};
#define display_Array_Uint8_t struct _display_Array_Uint8_t

struct _display_Array_Uint16_t {
	uint16_t *data;
	uint32_t size;
};
#define display_Array_Uint16_t struct _display_Array_Uint16_t

struct _display_Array_Uint32_t {
	uint32_t *data;
	uint32_t size;
};
#define display_Array_Uint32_t struct _display_Array_Uint32_t



enum _display_ErrorEnum_t {
	DISPLAY_NO_ERROR = 0,
	DISPLAY_SERVER_FAIL = -1,
	DISPLAY_ERROR_2 = -2,
	DISPLAY_ERROR_3 = -3
};
#define display_ErrorEnum_t enum _display_ErrorEnum_t

struct bst_probe_request {
	uint32_t guest_magic;
	uint32_t platform_id;
	uint32_t want_subdev;
	uint32_t want_layer_num;
	uint32_t want_info_size;
};

struct bst_probe_response {
	uint32_t guest_magic;
	uint32_t platform_id;
	uint32_t exec_subdev;
	uint32_t subdev_session;
	uint32_t status;
	uint32_t probed_info_size;
	// attach different subdev info
	// such as struct virt_dc_probe_info, struct virt_dp_probe_info ...
	uint32_t probed_info[16];
	// 1: means this guest os control the shared resource.
	// 0: means this guest os can't control but something to create a local object.
	uint8_t is_master;
};

struct _display_fw_cmd_head_t {
	uint32_t guest_magic;
	uint32_t subdev_session;
	uint8_t cmdset;
	uint8_t cmdid;
	uint8_t multicast_en;
	uint8_t sync_mode;
	uint8_t cmd_status;
	display_Array_Uint8_t magic;
	uint16_t sequ_cnt;
	uint16_t checksum;
	uint16_t priority;
	uint16_t uid;
};
#define display_fw_cmd_head_t struct _display_fw_cmd_head_t

struct _fw_msg_send_with_sync_out_t {
	display_Array_Uint32_t *user_ack_data;
	display_ErrorEnum_t *err;
};
#define fw_msg_send_with_sync_out_t struct _fw_msg_send_with_sync_out_t


static void build_command(struct fw_msg_data *msg_data, int cmdid,
			  uint32_t guest_magic, uint32_t *usr_param,
			  uint32_t size_param)
{
	msg_data->guest_magic = guest_magic;
	msg_data->cmdset = 0;
	msg_data->cmdid = cmdid;
	msg_data->size_cmd = size_param;
	memcpy(&msg_data->user_cmd_data[0], usr_param, size_param);
	/* for FW probe the subdev_session fix to 0*/
	msg_data->subdev_session = 0;
	msg_data->sync_mode = 0;
	memset(&msg_data->user_ack_data[0], 0, sizeof(msg_data->user_ack_data));
}
static void
fw_msg_send_with_sync_sync_callback(const display_Array_Uint32_t user_ack_data,
				    const display_ErrorEnum_t err, void *ext,
				    const uint32_t *info)
{
	fw_msg_send_with_sync_out_t *out = (fw_msg_send_with_sync_out_t *)ext;

	if (!out)
		return;
	out->user_ack_data->size = user_ack_data.size;
	out->user_ack_data->data = user_ack_data.data;
	*out->err = err;
}

static int32_t
fw_msg_send_with_sync_sync(const display_Array_Uint32_t user_cmd_data,
			   const display_fw_cmd_head_t fw_cmd_msg,
			   display_Array_Uint32_t *user_ack_data,
			   display_ErrorEnum_t *err, int64_t timeout_ms,
			   uint32_t *ext_buf)
{
	int32_t ret = 0;
	fw_msg_send_with_sync_out_t out = { .user_ack_data = user_ack_data,
					    .err = err };

	// send request
	// ret = send_request(data, ser, s_ext->cid,
	// 		   CMD_METHOD_FW_MSG_SEND_WITH_SYNC,
	// 		   fw_msg_send_with_sync_sync_callback, &out, ext_buf);
        fw_msg_send_with_sync_sync_callback(*user_ack_data, *err, &out,
                                            ext_buf);
        out.user_ack_data->data[0] = 0x1234;
        return ret;
}

int ipc_build_msg_cmd(struct fw_msg_data *msg_data)
{
	uint32_t buffer = 0;
	display_fw_cmd_head_t fw_cmd_msg = { 0 };
	display_ErrorEnum_t err = { 0 };
	static display_Array_Uint32_t user_cmd_data = { 0 };
	static display_Array_Uint32_t user_ack_data = { 0 };
	uint8_t magic_data[4] = { 0 };
	int32_t ret;

	if (!msg_data) {
		pr_info("msg_data is null !\n");
		return -1;
	}
	fw_cmd_msg.guest_magic = msg_data->guest_magic;
	fw_cmd_msg.subdev_session = msg_data->subdev_session;
	fw_cmd_msg.cmdset = msg_data->cmdset;
	fw_cmd_msg.cmdid = msg_data->cmdid;
	user_cmd_data.data = msg_data->user_cmd_data;
	user_cmd_data.size = sizeof(msg_data->user_cmd_data) / sizeof(uint32_t);
	fw_cmd_msg.magic.data = magic_data;
	fw_cmd_msg.magic.size = sizeof(magic_data);
	user_ack_data.data = msg_data->user_ack_data;
	user_ack_data.size = sizeof(msg_data->user_ack_data) / sizeof(uint32_t);
	// ret = __pclient->display_client.fw_msg_send_with_sync_async(user_cmd_data, fw_cmd_msg,
	// 				    on_fw_msg_send_with_sync_reply,
	// 				    msg_data->user_ack_data, &buffer);
	ret = fw_msg_send_with_sync_sync(
		user_cmd_data, fw_cmd_msg, &user_ack_data, &err,
		1000, &buffer);
	if (ret < 0) {
		pr_info(
			"send method fw_msg_send_with_sync failed. ret is %d\n",
			ret);
		return ret;
	}
	pr_info("[%s:%d] err:%#x msg_data->user_ack_data0:%#x\n", __func__,
		__LINE__, err, msg_data->user_ack_data[0]);
	pr_info("[%s:%d] err:%#x user_ack_data.data0:%#x\n", __func__, __LINE__,
		err, user_ack_data.data[0]);
	return 0;
}

int virt_glb_cmd_fw_probe(void)
{
	struct bst_probe_request request0;
    struct bst_probe_response response0;
    struct bst_probe_request *request = &request0;
    struct bst_probe_response *response = &response0;
    struct fw_msg_data msg_data;
	uint32_t req_size = sizeof(*request);
	uint32_t want_info_size = request->want_info_size;
	int ret = 0;

	build_command(&msg_data, 0, request->guest_magic,
		      (uint32_t *)request, req_size);
	ipc_build_msg_cmd(&msg_data);

	return 0;
}
// =========================================================================

/**
 * __set_bit - Set a bit in memory
 * @nr: the bit to set
 * @addr: the address to start counting from
 *
 * Unlike set_bit(), this function is non-atomic and may be reordered.
 * If it's called on the same region of memory simultaneously, the effect
 * may be that only one operation succeeds.
 */
static void _set_bit(int nr, volatile unsigned long *addr)
{
	unsigned long mask = BIT_MASK(nr);
	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
	pr_info("*p:%ld mask:%ld\n", *p, mask);
	*p |= mask;
	pr_info("*p:%ld\n", *p);
}

static void endian_swap(void)
{
	uint32_t hex = 0x01abcdef;
	pr_info("cpu_to_le32:%#x\n", cpu_to_le32(hex));
	pr_info("cpu_to_be32:%#x\n", cpu_to_be32(hex));

}

static int __init api_test_init(void)
{
	unsigned long bits = 0;
	unsigned long dstp_bits;
	int type = 10;
	pr_info("\n");
	pr_info("BITS_TO_LONGS(0):%ld\n", BITS_TO_LONGS(0));
	pr_info("BITS_TO_LONGS(3):%ld\n", BITS_TO_LONGS(3));
	pr_info("BITS_TO_LONGS(15):%ld\n", BITS_TO_LONGS(15));
	pr_info("BITS_TO_LONGS(16):%ld\n", BITS_TO_LONGS(16));
	pr_info("BITS_TO_LONGS(31):%ld\n", BITS_TO_LONGS(31));
	pr_info("BITS_TO_LONGS(32):%ld\n", BITS_TO_LONGS(32));
	pr_info("BITS_TO_LONGS(33):%ld\n", BITS_TO_LONGS(33));
	pr_info("BITS_TO_LONGS(34):%ld\n", BITS_TO_LONGS(34));
	pr_info("BITS_TO_LONGS:%ld\n",
		BITS_TO_LONGS(16) * sizeof(unsigned long));
	_set_bit(type, &bits);
	bitmap_zero(&dstp_bits, 16);
	pr_info("dstp_bits:%ld\n", dstp_bits);

	endian_swap();

	virt_glb_cmd_fw_probe();
	return 0;
}

static void __exit api_test_exit(void)
{
	pr_info("\n");
}

module_init(api_test_init);
module_exit(api_test_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("robin.jiang <jiangrenbin329@gmail.com>");
MODULE_DESCRIPTION("Kernel api test");