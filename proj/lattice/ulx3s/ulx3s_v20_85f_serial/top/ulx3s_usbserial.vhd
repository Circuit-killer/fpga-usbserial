-- (c)EMARD
-- License=BSD

-- module to bypass user input and usbserial to esp32 wifi

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library ecp5u;
use ecp5u.components.all;

-- USB packet generator functions
use work.usb_req_gen_func_pack.all;
-- package for decoded structure
use work.report_decoded_pack.all;

entity ulx3s_usbtest is
  generic
  (
    C_dummy_constant: integer := 0
  );
  port
  (
  clk_25mhz: in std_logic;  -- main clock input from 25MHz clock source

  -- UART0 (FTDI USB slave serial)
  ftdi_rxd: out   std_logic;
  ftdi_txd: in    std_logic;
  -- FTDI additional signaling
  ftdi_ndtr: inout  std_logic;
  ftdi_ndsr: inout  std_logic;
  ftdi_nrts: inout  std_logic;
  ftdi_txden: inout std_logic;

  -- UART1 (WiFi serial)
  wifi_rxd: out   std_logic;
  wifi_txd: in    std_logic;
  -- WiFi additional signaling
  wifi_en: inout  std_logic := 'Z'; -- '0' will disable wifi by default
  wifi_gpio0: inout std_logic;
  wifi_gpio2: inout std_logic;
  wifi_gpio15: inout std_logic;
  wifi_gpio16: inout std_logic;

  -- Onboard blinky
  led: out std_logic_vector(7 downto 0);
  btn: in std_logic_vector(6 downto 0);
  sw: in std_logic_vector(1 to 4);
  oled_csn, oled_clk, oled_mosi, oled_dc, oled_resn: out std_logic;

  -- GPIO (some are shared with wifi and adc)
  gp, gn: inout std_logic_vector(27 downto 0) := (others => 'Z');
  
  -- FPGA direct USB connector
  usb_fpga_dp: in std_logic; -- differential input
  usb_fpga_bd_dp, usb_fpga_bd_dn: inout std_logic; -- single ended bidirectional
  usb_fpga_pu_dp, usb_fpga_pu_dn: inout std_logic; -- pull up for slave, down for host mode

  -- Digital Video (differential outputs)
  --gpdi_dp, gpdi_dn: out std_logic_vector(2 downto 0);
  --gpdi_clkp, gpdi_clkn: out std_logic;

  -- Flash ROM (SPI0)
  --flash_miso   : in      std_logic;
  --flash_mosi   : out     std_logic;
  --flash_clk    : out     std_logic;
  --flash_csn    : out     std_logic;

  -- SD card (SPI1)
  --sd_dat3_csn, sd_cmd_di, sd_dat0_do, sd_dat1_irq, sd_dat2: inout std_logic := 'Z';
  --sd_clk: inout std_logic := 'Z';
  --sd_cdn, sd_wp: inout std_logic := 'Z'

  -- SHUTDOWN: logic '1' here will shutdown power on PCB >= v1.7.5
  shutdown: out std_logic := '0'
  );
end;

architecture Behavioral of ulx3s_usbtest is
  signal clk_100MHz, clk_60MHz, clk_7M5Hz, clk_12MHz: std_logic;
  signal S_reset: std_logic;
  signal S_usb_fpga_dn: std_logic;
  signal S_txdp, S_txdn, S_txoe: std_logic;
  signal S_hid_report: std_logic_vector(63 downto 0);
  signal S_LineState: std_logic_vector(1 downto 0);
begin
  clk_pll: entity work.clk_25M_100M_7M5_12M_60M
  port map
  (
      CLKI        =>  clk_25MHz,
      CLKOP       =>  clk_100MHz,
      CLKOS       =>  clk_7M5Hz,
      CLKOS2      =>  clk_12MHz,
      CLKOS3      =>  clk_60MHz
  );

  -- TX/RX passthru
  --ftdi_rxd <= wifi_txd;
  --wifi_rxd <= ftdi_txd;

  wifi_en <= '1';
  wifi_gpio0 <= btn(0);
  S_reset <= not btn(0);

  -- USB D+,D- pull down for host mode
  usb_fpga_pu_dp <= '1'; -- pullup for USB1.1 device
  usb_fpga_pu_dn <= 'Z';

  S_usb_fpga_dn <= not usb_fpga_dp;
  usb_fpga_bd_dp <= S_txdp when S_txoe = '1' else 'Z';
  usb_fpga_bd_dn <= S_txdn when S_txoe = '1' else 'Z';

  -- USB1.1 PHY
  usb11_phy: entity work.usb_phy
  generic map
  (
    usb_rst_det => true
  )
  port map
  (
    clk => clk_60MHz,
    rst => S_reset,
    phy_tx_mode => btn(1), -- 1-differential 0-single-ended
    usb_rst => open,
    -- transciever interface
    rxd => usb_fpga_dp,
    rxdp => usb_fpga_dp,
    rxdn => S_usb_fpga_dn,
    txdp => S_txdp,
    txdn => S_txdn,
    txoe => S_txoe,
    -- utmi interface
    DataOut_i => (others => '0'), -- 8-bit
    TxValid_i => '0',
    TxReady_o => open,
    DataIn_o => open, -- 8-bit
    RxValid_o => open,
    RxActive_o => open,
    RxError_o => open,
    LineState_o => S_LineState -- 2-bit
  );

  -- see the HID report on the OLED
  g_oled: if true generate
  oled_inst: entity work.oled
  generic map
  (
    C_data_len => S_hid_report'length
  )
  port map
  (
    clk => clk_7M5Hz,
    en => '1',
    data => S_hid_report(63 downto 0),
    spi_resn => oled_resn,
    spi_clk => oled_clk,
    spi_csn => oled_csn,
    spi_dc => oled_dc,
    spi_mosi => oled_mosi
  );
  end generate;

  led(7 downto 4) <= x"5";
  led(1 downto 0) <= S_LineState;

end Behavioral;
