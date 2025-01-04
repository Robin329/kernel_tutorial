#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/jiffies.h>
#include <linux/timekeeping.h>
#include <linux/time.h>
#include <linux/crc32.h>
#include <linux/delay.h>
#include <linux/hashtable.h>

/*
          A1 TX Key      A2 TX Key     B1 RX Key    B2 RX Key
Key
Selection b70361f714   43f72d5066      511ef21acd    e72697f401
Vector
------------------------------------------------------------------
Key 0  4da4588f131e69 9aaba1f9ef907c bc13e0c75bf0fd 93afe1ff4ca0ed
Key 1  1f823558e65009 34a0407731d1d0 ae0d2c7f76443b efb49d4a25a4e4
Key 2  8a6a47abb9980d 97c682992dc5d9 24bf2185a36c60 e822d8a9335346
Key 3  f3181b52cbc5ca da80caca68ed15 f4bc6cbcd7a32f 8812c3004e23d2
Key 4  fb147f6896d8b4 1866d9b51462a6 a72e69c5eb6388 dc63ba78d94263
Key 5  e08bc978488f81 d9fc9599bb7498 7fa2d27a37d9f8 47ebdf52776fd5
Key 6  a0d064c8112c41 7a062ac883f528 32fd3529dea3d1 4bce49472e0464
Key 7  b39d5a28242044 f5938c662af454 485fc240cc9bae 0479bed7732682
Key 8  b928b2bdad566b ec3075e82d3ef2 3b9857797d5103 c5f800fad716d5
Key 9  91a47b4a6ce4f6 536e376e7ffc49 0dd170be615250 f53fd67ba9b9ec
Key 10 5600f8205e9d58 51c83a6cbeb116 1a748be4866bb1 6fb3901e5867f2
Key 11 8c7fb706ee3fa0 79d44ae1bd5f50 f9606a7c348cca 24c46f520f1be5
Key 12 c02d8c9d7cbc28 674b2563e27393 4bbb037899eea1 2038176d369ed7
Key 13 561261e54b9f05 7a1357efc538a2 190ecf9cc095a9 9ba9cd6a077a57
Key 14 74f0de8ccac1cb 6486e57ea46b02 a821c46897447f 5f2764b35c5591
Key 15 3bb8f60efcdb6a bdf27a1ce8a299 1a8a0bc4298a41 ee32f1171f5356
Key 16 a02bbb16b22fd7 dc8bd1fa5b46b9 aefc0853e62082 d20a9e2f4d57fa
Key 17 482f8e46785498 27ef71efef9b73 f75d4a0c497ba4 439eb96d2daff0
Key 18 66ae2562274738 187599f603c947 ad6495fc8a06d8 1c68df6f868aaf
Key 19 3d4952a323ddf2 023ae9da303ecb 67c2020c2b2e02 dd50d7551dc6fb
Key 20 e2d231767b3a54 3d1cf6533dea8e 8f116b18f4ae8d 50b85379165c5f
Key 21 4d581aede66125 34dd5525f1890c e3053fa3e9fa69 f45d64b097d6b5
Key 22 326082bf7b22f7 367dd774a07f4c 37d8002881c7d1 a1a154e07adb4d
Key 23 f61b463530ce6b cdc34c8a6f56d1 c3a5fd1c15669c 0755ea83e47e71
Key 24 360409f0d7976b de3413927363a8 9e93d41e0811f7 e1dca26293efe4
Key 25 a1e105618d49f9 21b11c739f45b3 2c4074509eec6c e1092507ab8f45
Key 26 c98e9dd1053406 84440fadd281ac 8b7fd819279b61 3d56680db98e15
Key 27 20c36794426190 10f7900c65fef4 d7caada0a06ce9 0a49af413de66b
Key 28 964451ceac4fc3 30070704c8aa06 9297dca1f8c1db 90a814bbf971a0
Key 29 3e904504e18c8a f287cb4063cb9d 5d1aaa99dea489 626b121ca0504f
Key 30 290010579c2dfc 97033445a4d587 60cb56ddbaa1d9 00f9bb7a94a1a7
Key 31 d7943b69e5b180 8051045091c10b 85d4ad5e5ff2e0 f485290cc5c1ba
Key 32 54c7ea5bdd7b43 d18f282074da20 1280161221df6d baa873c54fdedf
Key 33 74fb5887c790ba f2679a98828400 ca31a5f2406589 2d6a56233b8aba
Key 34 935cfa364e1de0 a6f0b6042a3dd7 1d30e8cb198e6f a60d0379512312
Key 35 03075e159a11ae 3e5ddad097f5e1 d1c18bed07d3fa 942582078dadb8
Key 36 05d3408a78fb01 3ad1f8a2e5958f cec7ec09245b43 8395a4b022082f
Key 37 0059a5d7a04db3 f025bb1c085d4f b08129efedd583 cb12fe97842b60
Key 38 373b634a2c9e40 0864213d6d50c1 2134cf4ce286e5 282ffe78f2f95c
Key 39 2573bbb4562041 9018b0ff3ab170 edeef9d099b78c f6491f33c7ef53
*/

static u8 dpk_keys[] = {
#if 0
	0xfd, 0xb4, 0x3e, 0xa3, 0x4a, 0x41, 0xb3, 0x19, 0x3d, 0x8c, 0x54, 0xd4,
	0x62, 0x76, 0x26, 0x9e, 0x4b, 0x14, 0x29, 0x25, 0x38, 0xc0, 0x52, 0xaa,
	0x21, 0x2d, 0x4c, 0x33, 0xf7, 0x54, 0x32, 0xa4, 0x6e, 0x4c, 0x32, 0x0e,
	0x3f, 0x32, 0xa4, 0x49, 0x0e, 0x76, 0xb8, 0xac, 0xf1, 0xa4, 0x43, 0xa4,
	0x95, 0x8e, 0x6d, 0x2c, 0x14, 0xdd, 0x4e, 0xc8, 0xb7, 0x07, 0x36, 0xe3,
	0x1a, 0x68, 0x22, 0xa7, 0x83, 0x27, 0x5e, 0xc7, 0x5f, 0x1f, 0x49, 0x9f,
	0x00, 0xd7, 0xa9, 0x2c, 0x1f, 0xf9, 0x24, 0xe3, 0xff, 0x44, 0xbd, 0x40,
	0x7d, 0xeb, 0xac, 0x9e, 0xe5, 0xda, 0xfa, 0xff, 0x28, 0x36, 0x50, 0x91,
	0x17, 0x86, 0x88, 0x17, 0xf3, 0x98, 0x60, 0xf0, 0x77, 0x9a, 0xdc, 0x32,
	0x73, 0xe5, 0x4e, 0xbb, 0xd5, 0x45, 0x5e, 0xb9, 0x54, 0x94, 0x7c, 0xa8,
	0x01, 0x15, 0x55, 0xf3, 0xbd, 0xd2, 0x93, 0x45, 0xd2, 0x24, 0x2e, 0xaa,
	0xd6, 0x3c, 0xf1, 0x90, 0x8f, 0x38, 0x32, 0xda, 0x80, 0x44, 0xb1, 0xd9,
	0xa8, 0x8f, 0xeb, 0x59, 0x14, 0xaf, 0x8f, 0xcb, 0x24, 0xce, 0xac, 0xbf,
	0xcc, 0xe5, 0x26, 0x6b, 0xae, 0xa8, 0xf4, 0x17, 0xcf, 0xf7, 0x2a, 0x33,
	0x4a, 0xa3, 0xe9, 0x1b, 0x8a, 0x10, 0x4f, 0xd0, 0xf6, 0x10, 0xbf, 0xe1,
	0x10, 0xa4, 0x36, 0x1d, 0x86, 0xad, 0xed, 0x33, 0x79, 0x78, 0xaf, 0x5f,
	0x21, 0x87, 0xac, 0x36, 0xbb, 0xc8, 0xa3, 0xa8, 0x57, 0xaa, 0x00, 0x23,
	0xba, 0x1c, 0x01, 0x26, 0xfa, 0x73, 0xe3, 0x62, 0x3b, 0x5e, 0xb5, 0xe1,
	0x06, 0xf2, 0x32, 0x28, 0x98, 0xac, 0x19, 0x86, 0x73, 0x46, 0x2e, 0xf1,
	0x17, 0xd4, 0xd3, 0x30, 0x97, 0x10, 0x57, 0xf8, 0x9d, 0x92, 0x7c, 0x2a,
	0x43, 0x70, 0x45, 0x31, 0xba, 0xcd, 0xf7, 0xae, 0xc1, 0xe3, 0x27, 0xd5,
	0x89, 0xdc, 0x7d, 0x99, 0x2d, 0x03, 0xbf, 0x12, 0xb9, 0x8d, 0x95, 0xef,
	0x80, 0x96, 0xbb, 0xe9, 0x89, 0x24, 0x8c, 0x51, 0x61, 0x08, 0xd3, 0x2d,
	0x7c, 0xc1, 0x0a, 0x12
#else
	0x4d, 0xa4, 0x58, 0x8f, 0x13, 0x1e, 0x69, 0x1f, 0x82, 0x35, 0x58, 0xe6,
	0x50, 0x09, 0x8a, 0x6a, 0x47, 0xab, 0xb9, 0x98, 0x0d, 0xf3, 0x18, 0x1b,
	0x52, 0xcb, 0xc5, 0xca, 0xfb, 0x14, 0x7f, 0x68, 0x96, 0xd8, 0xb4, 0xe0,
	0x8b, 0xc9, 0x78, 0x48, 0x8f, 0x81, 0xa0, 0xd0, 0x64, 0xc8, 0x11, 0x2c,
	0x41, 0xb3, 0x9d, 0x5a, 0x28, 0x24, 0x20, 0x44, 0xb9, 0x28, 0xb2, 0xbd,
	0xad, 0x56, 0x6b, 0x91, 0xa4, 0x7b, 0x4a, 0x6c, 0xe4, 0xf6, 0x56, 0x00,
	0xf8, 0x20, 0x5e, 0x9d, 0x58, 0x8c, 0x7f, 0xb7, 0x06, 0xee, 0x3f, 0xa0,
	0xc0, 0x2d, 0x8c, 0x9d, 0x7c, 0xbc, 0x28, 0x56, 0x12, 0x61, 0xe5, 0x4b,
	0x9f, 0x05, 0x74, 0xf0, 0xde, 0x8c, 0xca, 0xc1, 0xcb, 0x3b, 0xb8, 0xf6,
	0x0e, 0xfc, 0xdb, 0x6a, 0xa0, 0x2b, 0xbb, 0x16, 0xb2, 0x2f, 0xd7, 0x48,
	0x2f, 0x8e, 0x46, 0x78, 0x54, 0x98, 0x66, 0xae, 0x25, 0x62, 0x27, 0x47,
	0x38, 0x3d, 0x49, 0x52, 0xa3, 0x23, 0xdd, 0xf2, 0xe2, 0xd2, 0x31, 0x76,
	0x7b, 0x3a, 0x54, 0x4d, 0x58, 0x1a, 0xed, 0xe6, 0x61, 0x25, 0x32, 0x60,
	0x82, 0xbf, 0x7b, 0x22, 0xf7, 0xf6, 0x1b, 0x46, 0x35, 0x30, 0xce, 0x6b,
	0x36, 0x04, 0x09, 0xf0, 0xd7, 0x97, 0x6b, 0xa1, 0xe1, 0x05, 0x61, 0x8d,
	0x49, 0xf9, 0xc9, 0x8e, 0x9d, 0xd1, 0x05, 0x34, 0x06, 0x20, 0xc3, 0x67,
	0x94, 0x42, 0x61, 0x90, 0x96, 0x44, 0x51, 0xce, 0xac, 0x4f, 0xc3, 0x3e,
	0x90, 0x45, 0x04, 0xe1, 0x8c, 0x8a, 0x29, 0x00, 0x10, 0x57, 0x9c, 0x2d,
	0xfc, 0xd7, 0x94, 0x3b, 0x69, 0xe5, 0xb1, 0x80, 0x54, 0xc7, 0xea, 0x5b,
	0xdd, 0x7b, 0x43, 0x74, 0xfb, 0x58, 0x87, 0xc7, 0x90, 0xba, 0x93, 0x5c,
	0xfa, 0x36, 0x4e, 0x1d, 0xe0, 0x03, 0x07, 0x5e, 0x15, 0x9a, 0x11, 0xae,
	0x05, 0xd3, 0x40, 0x8a, 0x78, 0xfb, 0x01, 0x00, 0x59, 0xa5, 0xd7, 0xa0,
	0x4d, 0xb3, 0x37, 0x3b, 0x63, 0x4a, 0x2c, 0x9e, 0x40, 0x25, 0x73, 0xbb,
	0xb4, 0x56, 0x20, 0x41,
#endif
};

static u8 dpk_keys_rev[280] = {0};
static u8 sw_enc_key[2] = { 0x12, 0x5e };
static u32 hw_enc_key = 0xcac;
static u8 dpk_enc_keys[280] = { 0 };

static uint32_t edp_crc32(uint8_t *dpk_keys, int len)
{
	int ix;
	uint32_t crc32;
	uint32_t crc = 0xFFFFFFFF;
	uint32_t i_crc, bitmapped_crc;
	u8 bit0, bit1, bit2, bit4, bit5, bit7, bit8, bit10, bit11, bit12, bit16,
		bit22, bit23, bit26;
	int number_of_bits = 0;
	int number_of_56bitswords = 0;
	u64 words[40] = { 0 };
	u64 words_reverse[40] = { 0 };
	u64 bit_stream[40] = { 0 };
	int count, i = 0;
    u64 rem = 0;
    u32 crc_tmp;

	pr_info ("sizeof dpk_keys:%d\n", len);
    for (count = 0, i = 0; count < len; count += 7)
	{
		words[i] =  ((unsigned long long)dpk_keys[count + 6] << 0);
		words[i] |= ((unsigned long long)dpk_keys[count + 5] << 8);
		words[i] |= ((unsigned long long)dpk_keys[count + 4] << 16);
		words[i] |= ((unsigned long long)dpk_keys[count + 3] << 24);
		words[i] |= ((unsigned long long)dpk_keys[count + 2] << 32);
		words[i] |= ((unsigned long long)dpk_keys[count + 1] << 40);
		words[i] |= ((unsigned long long)dpk_keys[count] << 48);
		pr_info("words[%d]=%#llx %#x %#x %#x %#x %#x %#x %#x\n", i,
			words[i], dpk_keys[count + 6], dpk_keys[count + 5],
			dpk_keys[count + 4], dpk_keys[count + 3],
			dpk_keys[count + 2], dpk_keys[count + 1],
			dpk_keys[count]);
		i++;
	}

	number_of_56bitswords = len / 7;
	if (number_of_56bitswords == 0) {
		crc32 = 0x00000000;
		return crc32;
	}
	// Serialize the data
	// for (ix = 0; ix < number_of_56bitswords; ix++) {
	// 	// bit_stream = bit_stream << 56;
	// 	// bit_stream [55:0] = words[(number_of_56bitswords - 1) - ix];
	// 	words_reverse[ix] = words[(number_of_56bitswords - 1) - ix];
	// 	//$display("\n CRC calculation done word 32'h%8h", words[(number_of_56bitswords - 1) - ix]);
	// }
	number_of_bits = number_of_56bitswords * 56;
	pr_info("number_of_bits:%d\n",
		number_of_bits);
    for (ix = 0; ix < number_of_bits; ix++)
	{
		i = ix / 56 ;
		rem = ix % 56;
        // pr_info("i:%d rem:%d\n", i, rem);
        bit_stream[i] = words[i];

		bit0 = ((crc & BIT(31)) >> 31) ^ ((bit_stream[i] & BIT((rem))) >> (rem));
		// pr_info("bit0:%x  bit_stream[%d]:%x", bit0, ix,
		// 	((bit_stream[i] & BIT((rem))) >> (rem)));
		bit1 = ((crc & BIT(0)) >> 0) ^ bit0;
        
		bit2 = ((crc & BIT(1)) >> 1) ^ bit0;
		bit4 = ((crc & BIT(3)) >> 3)  ^ bit0;
		bit5 = ((crc & BIT(4)) >> 4)  ^ bit0;
		bit7 = ((crc & BIT(6)) >> 6)  ^ bit0;
		bit8 = ((crc & BIT(7)) >> 7) ^ bit0;
		bit10 = ((crc & BIT(9)) >> 9) ^ bit0;
		bit11 = ((crc & BIT(10)) >> 10) ^ bit0;
		bit12 = ((crc & BIT(11)) >> 11) ^ bit0;
		bit16 = ((crc & BIT(15)) >> 15) ^ bit0;
		bit22 = ((crc & BIT(21)) >> 21) ^ bit0;
		bit23 = ((crc & BIT(22)) >> 22) ^ bit0;
		bit26 = ((crc & BIT(25)) >> 25) ^ bit0;
		pr_info("bit1:%d bit2:%d bit4:%d bit5:%d bit7:%d bit8:%d bit10:%d bit11:%d bit12:%d bit16:%d bit22:%d bit23:%d bit26:%d\n",
			bit1, bit2, bit4, bit5, bit7, bit8, bit10, bit11, bit12,
			bit16, bit22, bit23, bit26);
		crc_tmp  = crc;
        crc = bit0 << 0;
		crc |= bit1 << 1;
		crc |= bit2 << 2;
		crc |= ((crc_tmp & BIT(2)) >> 2) << 3;
		crc |= bit4 << 4;
		crc |= bit5 << 5;
		crc |= ((crc_tmp & BIT(5)) >> 5) << 6;
		crc |= bit7 << 7;
		crc |= bit8 << 8;
		crc |= ((crc_tmp & BIT(8)) >> 8) << 9;
		crc |= bit10 << 10;
		crc |= bit11 << 11;
		crc |= bit12 << 12;
		crc |= ((crc_tmp & GENMASK(14, 12)) >> 12) << 13;
		crc |= bit16 << 16;
		crc |= ((crc_tmp & GENMASK(20, 16)) >> 16) << 17;
		crc |= bit22 << 22;
		crc |= bit23 << 23;
		crc |= ((crc_tmp & GENMASK(24, 23)) >> 23) << 24;
		crc |= bit26 << 26;
		crc |= ((crc_tmp & GENMASK(31, 26)) >> 26) << 27;
		pr_info("crc:%x\n", crc);
	}

	crc32 = crc;
    pr_info("crc32:%#x\n", crc32);
    return crc32;
}


static int __init crc_calc_init(void)
{
    int count = 0;
    u8 tmp[7] = {0};
    int key_nr, dpk_count;
    u32 reg_m, reg_l;
    u32 SR1 = (hw_enc_key << 16) | (sw_enc_key[0] << 8) | (sw_enc_key[1]);
    u32 SR2 = 0x1978F5E;
    u8 mask = 0;
    int j, i;

    // hparams->hdcp13_is_en = 0;
    //-------------------------------------------------------------------------
    // STEP 4: Encrypt Keys
    //-------------------------------------------------------------------------
    for (j = 0; j < 40; j = j + 1) {
	    for (i = 0; i < 7; i = i + 1) {
		    //mask gen
		    mask = (SR2 & BIT(0)) << 7;
		    mask |= ((SR2 & BIT(2)) >> 2) << 6;
		    mask |= ((SR2 & BIT(4)) >> 4) << 5;
		    mask |= ((SR2 & BIT(6)) >> 6) << 4;
		    mask |= ((SR2 & BIT(1)) >> 1) << 3;
		    mask |= ((SR2 & BIT(3)) >> 3) << 2;
		    mask |= ((SR2 & BIT(5)) >> 5) << 1;
		    mask |= ((SR2 & BIT(7)) >> 7) << 0;
		    //SR2 shift + bit manipulation
		    SR2 = ((((SR2 & BIT(0)) << 24) | ((SR2 & GENMASK(24, 1)) >> 1)) ^ (SR1 & GENMASK(24, 0))) & 0x1FFFFFF;
		    //SR1 shift left + bit manipulation
		    SR1 = ((((SR1 & GENMASK(26, 0)) << 1) | ((SR1 & BIT(27)) >> 27)) & 0XFFFFFFE) +  ((SR1 >> 27) ^ ((SR1 >> 24) & 1));
		    //Encrypt Key
		    dpk_enc_keys[j * 7 + i] = dpk_keys[j * 7 + i] ^ mask;
		    // pr_info("mask:%#x SR2:%#x SR1:%#x dpk_enc_keys[%d]:%02x\n", mask, SR2, SR1, j * 7 + i,
			//     dpk_enc_keys[j * 7 + i]);
	    }
    }
    for (count = 0; count < sizeof(dpk_keys); count+=7) {
        tmp[0] = dpk_keys[count + 6];
        tmp[1] = dpk_keys[count + 5];
        tmp[2] = dpk_keys[count + 4];
        tmp[3] = dpk_keys[count + 3];
        tmp[4] = dpk_keys[count + 2];
        tmp[5] = dpk_keys[count + 1];
        tmp[6] = dpk_keys[count];
        memcpy(&dpk_keys_rev[count], tmp, sizeof(tmp));
    }
    // for (count = 0; count < sizeof(dpk_keys_rev); count++) {
    //     pr_info("0x%02x", dpk_keys_rev[count]);
    //     // if (count % 8 == 0)
    //     //     pr_info("\n");
    // }
    dpk_count = 0;
    for (key_nr = 0; key_nr < 280; key_nr = key_nr + 7)
    {
	    reg_m = 0;
	    reg_m |= dpk_enc_keys[key_nr] << 16;
	    reg_m |= dpk_enc_keys[key_nr + 1] << 8;
	    reg_m |= dpk_enc_keys[key_nr + 2] << 0;

	    // reg |= dpk_enc_keys[key_nr + 6] << 16;
	    // reg |= dpk_enc_keys[key_nr + 5] << 8;
	    // reg |= dpk_enc_keys[key_nr + 4] << 0;
	    // dpk.msb = reg;
	    reg_l = 0;
	    reg_l |= dpk_enc_keys[key_nr + 3] << 24;
	    reg_l |= dpk_enc_keys[key_nr + 4] << 16;
	    reg_l |= dpk_enc_keys[key_nr + 5] << 8;
	    reg_l |= dpk_enc_keys[key_nr + 6] << 0;

	    // reg |= dpk_enc_keys[key_nr + 3] << 24;
	    // reg |= dpk_enc_keys[key_nr + 2] << 16;
	    // reg |= dpk_enc_keys[key_nr + 1] << 8;
	    // reg |= dpk_enc_keys[key_nr] << 0;
	    // dpk.lsb = reg;

	    pr_info("%d:%#llx\n", dpk_count,
		    (unsigned long long)reg_m << 32 | (unsigned long long)reg_l);
		    dpk_count++;
    }
    pr_info("crc32:%#x\n", edp_crc32(dpk_enc_keys, sizeof(dpk_enc_keys)));
	    // pr_info("crc32_be:%#x\n",
	    //     crc32_be(~0, dpk_enc_keys, sizeof(dpk_enc_keys)) ^ (~0));
	    // pr_info("crc32_le:%#x\n",
	    //     crc32_le(~0, dpk_enc_keys, sizeof(dpk_enc_keys)) ^ (~0));
	    return 0;
}
static void __exit crc_calc_exit(void)
{
	printk(KERN_INFO "Exiting crc_calc_exit\n");
}

module_init(crc_calc_init);
module_exit(crc_calc_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Robin");
MODULE_DESCRIPTION("A module to calc crc");