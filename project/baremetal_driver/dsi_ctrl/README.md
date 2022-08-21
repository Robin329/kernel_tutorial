
### Reference

/home/robin/workspace/project/android11_kernel_msm/private/msm-google/drivers/gpu/drm/msm/dsi-staging/

### debugfs path
```bash
crosshatch:/sys/kernel/debug/dsi_s6e3ha8_cmd_display # ls -al
total 0
drwxr-xr-x  6 root root 0 1970-01-01 08:00 .
drwxr-xr-x 93 root root 0 2022-05-10 00:47 ..
drwxr-xr-x  2 root root 0 1970-01-01 08:00 cmd_sets
drwxr-xr-x  2 root root 0 1970-01-01 08:00 dsi-ctrl-0
-rw-------  1 root root 0 1970-01-01 08:00 dsi-phy-0_allow_phy_power_off
-rw-------  1 root root 0 1970-01-01 08:00 dsi-phy-0_regulator_min_datarate_bps
-r--------  1 root root 0 1970-01-01 08:00 dump_info
-rw-r--r--  1 root root 0 1970-01-01 08:00 esd_check_mode
-rw-r--r--  1 root root 0 1970-01-01 08:00 esd_trigger
drwxr-xr-x  5 root root 0 1970-01-01 08:00 lp_modes
-rw-------  1 root root 0 1970-01-01 08:00 misr_data
drwxr-xr-x  2 root root 0 1970-01-01 08:00 panel_reg
-rw-------  1 root root 0 1970-01-01 08:00 ulps_enable
-rw-------  1 root root 0 1970-01-01 08:00 ulps_suspend_enable
```
- DTSI

  ```
	dsi_s6e3ha8_cmd_display: qcom,dsi-display@52 {
		compatible = "qcom,dsi-display";
		label = "dsi_s6e3ha8_cmd_display";
		qcom,display-type = "primary";

		qcom,dsi-ctrl = <&mdss_dsi0>;
		qcom,dsi-phy = <&mdss_dsi_phy0>;
		clocks = <&mdss_dsi0_pll BYTECLK_MUX_0_CLK>,
			<&mdss_dsi0_pll PCLK_MUX_0_CLK>;
		clock-names = "src_byte_clk", "src_pixel_clk";

		pinctrl-names = "panel_active", "panel_suspend";
		pinctrl-0 = <&sde_dsi_active &sde_te_active  &se8_spiflash>;
		pinctrl-1 = <&sde_dsi_suspend &sde_te_suspend>;

		qcom,dsi-panel = <&dsi_s6e3ha8_dsc_wqhd_cmd>;

		vddi-supply = <&pm8998_l14>;
		vci-supply = <&pm8998_l28>;
		lab-supply = <&lab_regulator>;
	};
	// private/msm-google/arch/arm64/boot/dts/google/dsi-panel-s6e3ha8-dsc-wqhd-cmd.dtsi

	&mdss_mdp {
	dsi_s6e3ha8_dsc_wqhd_cmd: qcom,mdss_dsi_s6e3ha8 {
		compatible = "google,dsi_binned_lp";
		...

  ```

### MIPI DSI FLOW

```
dsi_panel_parse_cmd_sets_dt
	dsi_panel_parse_dt_cmd_set

/* transfer the mipi cmds */
dsi_panel_tx_cmd_set
	dsi_panel_cmd_set_transfer
		dsi_display_cmd_transfer
		dsi_host_transfer

msm_atomic_helper_commit_modeset_enables
	sde_kms_complete_commit
```

### DRM Radeon

radeon.h:
```
/*
 * ASIC specific functions.
 */
struct radeon_asic {
	int (*init)(struct radeon_device *rdev);
	void (*fini)(struct radeon_device *rdev);
	int (*resume)(struct radeon_device *rdev);
	int (*suspend)(struct radeon_device *rdev);
	void (*vga_set_state)(struct radeon_device *rdev, bool state);
	int (*asic_reset)(struct radeon_device *rdev, bool hard);
	/* Flush the HDP cache via MMIO */
	void (*mmio_hdp_flush)(struct radeon_device *rdev);
	/* check if 3D engine is idle */
	bool (*gui_idle)(struct radeon_device *rdev);
	/* wait for mc_idle */
	int (*mc_wait_for_idle)(struct radeon_device *rdev);
	/* get the reference clock */
	u32 (*get_xclk)(struct radeon_device *rdev);
	/* get the gpu clock counter */
	uint64_t (*get_gpu_clock_counter)(struct radeon_device *rdev);
	/* get register for info ioctl */
	int (*get_allowed_info_register)(struct radeon_device *rdev, u32 reg, u32 *val);
	/* gart */
	struct {
		void (*tlb_flush)(struct radeon_device *rdev);
		uint64_t (*get_page_entry)(uint64_t addr, uint32_t flags);
		void (*set_page)(struct radeon_device *rdev, unsigned i,
				 uint64_t entry);
	} gart;
	struct {
		int (*init)(struct radeon_device *rdev);
		void (*fini)(struct radeon_device *rdev);
		void (*copy_pages)(struct radeon_device *rdev,
				   struct radeon_ib *ib,
				   uint64_t pe, uint64_t src,
				   unsigned count);
		void (*write_pages)(struct radeon_device *rdev,
				    struct radeon_ib *ib,
				    uint64_t pe,
				    uint64_t addr, unsigned count,
				    uint32_t incr, uint32_t flags);
		void (*set_pages)(struct radeon_device *rdev,
				  struct radeon_ib *ib,
				  uint64_t pe,
				  uint64_t addr, unsigned count,
				  uint32_t incr, uint32_t flags);
		void (*pad_ib)(struct radeon_ib *ib);
	} vm;
	/* ring specific callbacks */
	const struct radeon_asic_ring *ring[RADEON_NUM_RINGS];
	/* irqs */
	struct {
		int (*set)(struct radeon_device *rdev);
		int (*process)(struct radeon_device *rdev);
	} irq;
	/* displays */
	struct {
		/* display watermarks */
		void (*bandwidth_update)(struct radeon_device *rdev);
		/* get frame count */
		u32 (*get_vblank_counter)(struct radeon_device *rdev, int crtc);
		/* wait for vblank */
		void (*wait_for_vblank)(struct radeon_device *rdev, int crtc);
		/* set backlight level */
		void (*set_backlight_level)(struct radeon_encoder *radeon_encoder, u8 level);
		/* get backlight level */
		u8 (*get_backlight_level)(struct radeon_encoder *radeon_encoder);
		/* audio callbacks */
		void (*hdmi_enable)(struct drm_encoder *encoder, bool enable);
		void (*hdmi_setmode)(struct drm_encoder *encoder, struct drm_display_mode *mode);
	} display;
	/* copy functions for bo handling */
	struct {
		struct radeon_fence *(*blit)(struct radeon_device *rdev,
					     uint64_t src_offset,
					     uint64_t dst_offset,
					     unsigned num_gpu_pages,
					     struct reservation_object *resv);
		u32 blit_ring_index;
		struct radeon_fence *(*dma)(struct radeon_device *rdev,
					    uint64_t src_offset,
					    uint64_t dst_offset,
					    unsigned num_gpu_pages,
					    struct reservation_object *resv);
		u32 dma_ring_index;
		/* method used for bo copy */
		struct radeon_fence *(*copy)(struct radeon_device *rdev,
					     uint64_t src_offset,
					     uint64_t dst_offset,
					     unsigned num_gpu_pages,
					     struct reservation_object *resv);
		/* ring used for bo copies */
		u32 copy_ring_index;
	} copy;
	/* surfaces */
	struct {
		int (*set_reg)(struct radeon_device *rdev, int reg,
				       uint32_t tiling_flags, uint32_t pitch,
				       uint32_t offset, uint32_t obj_size);
		void (*clear_reg)(struct radeon_device *rdev, int reg);
	} surface;
	/* hotplug detect */
	struct {
		void (*init)(struct radeon_device *rdev);
		void (*fini)(struct radeon_device *rdev);
		bool (*sense)(struct radeon_device *rdev, enum radeon_hpd_id hpd);
		void (*set_polarity)(struct radeon_device *rdev, enum radeon_hpd_id hpd);
	} hpd;
	/* static power management */
	struct {
		void (*misc)(struct radeon_device *rdev);
		void (*prepare)(struct radeon_device *rdev);
		void (*finish)(struct radeon_device *rdev);
		void (*init_profile)(struct radeon_device *rdev);
		void (*get_dynpm_state)(struct radeon_device *rdev);
		uint32_t (*get_engine_clock)(struct radeon_device *rdev);
		void (*set_engine_clock)(struct radeon_device *rdev, uint32_t eng_clock);
		uint32_t (*get_memory_clock)(struct radeon_device *rdev);
		void (*set_memory_clock)(struct radeon_device *rdev, uint32_t mem_clock);
		int (*get_pcie_lanes)(struct radeon_device *rdev);
		void (*set_pcie_lanes)(struct radeon_device *rdev, int lanes);
		void (*set_clock_gating)(struct radeon_device *rdev, int enable);
		int (*set_uvd_clocks)(struct radeon_device *rdev, u32 vclk, u32 dclk);
		int (*set_vce_clocks)(struct radeon_device *rdev, u32 evclk, u32 ecclk);
		int (*get_temperature)(struct radeon_device *rdev);
	} pm;
	/* dynamic power management */
	struct {
		int (*init)(struct radeon_device *rdev);
		void (*setup_asic)(struct radeon_device *rdev);
		int (*enable)(struct radeon_device *rdev);
		int (*late_enable)(struct radeon_device *rdev);
		void (*disable)(struct radeon_device *rdev);
		int (*pre_set_power_state)(struct radeon_device *rdev);
		int (*set_power_state)(struct radeon_device *rdev);
		void (*post_set_power_state)(struct radeon_device *rdev);
		void (*display_configuration_changed)(struct radeon_device *rdev);
		void (*fini)(struct radeon_device *rdev);
		u32 (*get_sclk)(struct radeon_device *rdev, bool low);
		u32 (*get_mclk)(struct radeon_device *rdev, bool low);
		void (*print_power_state)(struct radeon_device *rdev, struct radeon_ps *ps);
		void (*debugfs_print_current_performance_level)(struct radeon_device *rdev, struct seq_file *m);
		int (*force_performance_level)(struct radeon_device *rdev, enum radeon_dpm_forced_level level);
		bool (*vblank_too_short)(struct radeon_device *rdev);
		void (*powergate_uvd)(struct radeon_device *rdev, bool gate);
		void (*enable_bapm)(struct radeon_device *rdev, bool enable);
		void (*fan_ctrl_set_mode)(struct radeon_device *rdev, u32 mode);
		u32 (*fan_ctrl_get_mode)(struct radeon_device *rdev);
		int (*set_fan_speed_percent)(struct radeon_device *rdev, u32 speed);
		int (*get_fan_speed_percent)(struct radeon_device *rdev, u32 *speed);
		u32 (*get_current_sclk)(struct radeon_device *rdev);
		u32 (*get_current_mclk)(struct radeon_device *rdev);
	} dpm;
	/* pageflipping */
	struct {
		void (*page_flip)(struct radeon_device *rdev, int crtc, u64 crtc_base, bool async);
		bool (*page_flip_pending)(struct radeon_device *rdev, int crtc);
	} pflip;
};
```


### write interface

```c
/**
 * mipi_dsi_generic_write() - transmit data using a generic write packet
 * @dsi: DSI peripheral device
 * @payload: buffer containing the payload
 * @size: size of payload buffer
 *
 * This function will automatically choose the right data type depending on
 * the payload length.
 *
 * Return: The number of bytes transmitted on success or a negative error code
 * on failure.
 */
ssize_t mipi_dsi_generic_write(struct mipi_dsi_device *dsi, const void *payload,
			       size_t size)
{
	struct mipi_dsi_msg msg = {
		.channel = dsi->channel,
		.tx_buf = payload,
		.tx_len = size
	};

	switch (size) {
	case 0:
		msg.type = MIPI_DSI_GENERIC_SHORT_WRITE_0_PARAM;
		break;

	case 1:
		msg.type = MIPI_DSI_GENERIC_SHORT_WRITE_1_PARAM;
		break;

	case 2:
		msg.type = MIPI_DSI_GENERIC_SHORT_WRITE_2_PARAM;
		break;

	default:
		msg.type = MIPI_DSI_GENERIC_LONG_WRITE;
		break;
	}

	return mipi_dsi_device_transfer(dsi, &msg);
}
EXPORT_SYMBOL(mipi_dsi_generic_write);

/**
 * mipi_dsi_dcs_write_buffer() - transmit a DCS command with payload
 * @dsi: DSI peripheral device
 * @data: buffer containing data to be transmitted
 * @len: size of transmission buffer
 *
 * This function will automatically choose the right data type depending on
 * the command payload length.
 *
 * Return: The number of bytes successfully transmitted or a negative error
 * code on failure.
 */
ssize_t mipi_dsi_dcs_write_buffer(struct mipi_dsi_device *dsi,
				  const void *data, size_t len)
{
	struct mipi_dsi_msg msg = {
		.channel = dsi->channel,
		.tx_buf = data,
		.tx_len = len
	};

	switch (len) {
	case 0:
		return -EINVAL;

	case 1:
		msg.type = MIPI_DSI_DCS_SHORT_WRITE;
		break;

	case 2:
		msg.type = MIPI_DSI_DCS_SHORT_WRITE_PARAM;
		break;

	default:
		msg.type = MIPI_DSI_DCS_LONG_WRITE;
		break;
	}

	return mipi_dsi_device_transfer(dsi, &msg);
}
EXPORT_SYMBOL(mipi_dsi_dcs_write_buffer);

```