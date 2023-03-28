---------------------------------------------------------------------------
--  Copyright 2015 - 2017 Systems Group, ETH Zurich
-- 
--  This hardware module is free software: you can redistribute it and/or
--  modify it under the terms of the GNU General Public License as published
--  by the Free Software Foundation, either version 3 of the License, or
--  (at your option) any later version.
-- 
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
-- 
--  You should have received a copy of the GNU General Public License
--  along with this program.  If not, see <http://www.gnu.org/licenses/>.
---------------------------------------------------------------------------

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;
USE IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_unsigned.ALL;
use std.textio.all;
USE IEEE.std_logic_textio.ALL;

entity testbench_toplevel is
end testbench_toplevel;

architecture bench of testbench_toplevel is

  component tcp_top_loopback 
  generic (
       IS_SIM : integer := 0 
    );
    port (
      aclk : in std_logic;
      aresetn : in std_logic;
            
      m_axis_open_connection_TVALID : out std_logic;
      m_axis_open_connection_TREADY : in std_logic;
      m_axis_open_connection_TDATA: out std_logic_vector(47 downto 0);
      
      s_axis_open_status_TVALID : in std_logic;
      s_axis_open_status_TREADY : out std_logic;
      s_axis_open_status_TDATA: in std_logic_vector(23 downto 0);
      
      m_axis_close_connection_TVALID : out std_logic;
      m_axis_close_connection_TREADY : in std_logic;
      m_axis_close_connection_TDATA: out std_logic_vector(15 downto 0);

      m_axis_listen_port_TVALID : out std_logic;
      m_axis_listen_port_TREADY : in std_logic;
      m_axis_listen_port_TDATA: out std_logic_vector(15 downto 0);

      s_axis_listen_port_status_TVALID : in std_logic;
      s_axis_listen_port_status_TREADY : out std_logic;
      s_axis_listen_port_status_TDATA : in std_logic_vector(7 downto 0);

      s_axis_notifications_TVALID : in std_logic;
      s_axis_notifications_TREADY : out std_logic;
      s_axis_notifications_TDATA : in std_logic_vector(87 downto 0);

      m_axis_read_package_TVALID : out std_logic;
      m_axis_read_package_TREADY : in std_logic;
      m_axis_read_package_TDATA: out std_logic_vector(31 downto 0);
      
      m_axis_tx_data_TVALID : out std_logic;
      m_axis_tx_data_TREADY : in std_logic;
      m_axis_tx_data_TDATA: out std_logic_vector(511 downto 0);
      m_axis_tx_data_TKEEP: out std_logic_vector(63 downto 0);
      m_axis_tx_data_TLAST: out std_logic_vector(0 downto 0);
      
      m_axis_tx_metadata_TVALID : out std_logic;
      m_axis_tx_metadata_TREADY : in std_logic;
      m_axis_tx_metadata_TDATA: out std_logic_vector(31 downto 0);
      
      s_axis_tx_status_TVALID : in std_logic;
      s_axis_tx_status_TREADY : out std_logic;
      s_axis_tx_status_TDATA : in std_logic_vector(63 downto 0);
      
      s_axis_rx_data_TVALID : in std_logic;
      s_axis_rx_data_TREADY : out std_logic;
      s_axis_rx_data_TDATA : in std_logic_vector(511 downto 0);
      s_axis_rx_data_TKEEP:  in std_logic_vector(63 downto 0);
      s_axis_rx_data_TLAST: in std_logic_vector(0 downto 0);
      
      s_axis_rx_metadata_TVALID: in std_logic;
      s_axis_rx_metadata_TREADY : out std_logic;
      s_axis_rx_metadata_TDATA: in std_logic_vector(15 downto 0)
      
      
      );
  end component;
  

  signal clk: std_logic := '0';
  signal fclk: std_logic := '0';
  signal clk200: std_logic := '1';
  signal rst: std_logic := '1';
  signal rstX: std_logic := '1';
  signal rstn: std_logic;
  signal event_valid: std_logic;
  signal event_ready: std_logic;
  signal event_data: std_logic_vector(87 downto 0);
  signal readreq_valid: std_logic;
  signal readreq_ready: std_logic := '1';
  signal readreq_data: std_logic_vector(31 downto 0);
  signal packet_valid: std_logic;
  signal packet_ready: std_logic;
  signal packet_data: std_logic_vector(511 downto 0);
  signal packet_keep: std_logic_vector(7 downto 0);
  signal packet_last: std_logic_vector(0 downto 0);
  signal out_valid: std_logic;
  signal out_ready: std_logic := '1';
  signal out_last: std_logic_vector(0 downto 0);
  signal out_data: std_logic_vector(511 downto 0);
  signal out_meta_valid : std_logic;
  signal out_meta: std_logic_vector(31 downto 0) ;

  signal tx_status_data : std_logic_vector(63 downto 0);
  signal tx_status_valid : std_logic;
  signal tx_status_ready : std_logic;
  
  signal waiting : std_logic_vector(15 downto 0);
  signal waiting2 : std_logic_vector(15 downto 0);
  
  signal openConnReqValid : std_logic;
  signal openConnRespValid : std_logic;
  signal openConnRespReady : std_logic;
  
  signal waitLast : std_logic;
  
  signal cntReady : std_logic_vector(7 downto 0);
  signal cntReady2 : std_logic_vector(7 downto 0);
  signal metaReady : std_logic := '0';
      
  signal ticker : std_logic_vector(23 downto 0) := (others=>'0') ;
  
  
  signal count : std_logic_vector(63 downto 0) := (others => '0');
  
   
begin

  
    uut: tcp_top_loopback 
    generic map ( 
    IS_SIM => 1   
    )    port map ( 
            aclk           => clk,
	       aresetn        => rstn,
	       
	       m_axis_open_connection_TVALID => openConnReqValid,
	       m_axis_open_connection_TREADY =>  '1',
	       s_axis_open_status_TVALID => openConnRespValid,
	       s_axis_open_status_TREADY => openConnRespReady,
	       s_axis_open_status_TDATA => ticker,
	       m_axis_close_connection_TREADY => '1',	       
	       m_axis_listen_port_TREADY => '1',
	       s_axis_listen_port_status_TVALID =>  '0',
	       s_axis_listen_port_status_TDATA => (others => '0'),
	       
	       
	       s_axis_notifications_TVALID => event_valid,
	       s_axis_notifications_TREADY => event_ready,
	       s_axis_notifications_TDATA => event_data,
	       
	       m_axis_read_package_TVALID => readreq_valid,
	       m_axis_read_package_TREADY => readreq_ready,
	       m_axis_read_package_TDATA => readreq_data,

	       m_axis_tx_data_TVALID => out_valid,
               m_axis_tx_data_TREADY => out_ready,
	       m_axis_tx_data_TDATA => out_data,
	       m_axis_tx_data_TLAST => out_last,
	       
	       m_axis_tx_metadata_TVALID => out_meta_valid,
               m_axis_tx_metadata_TREADY => metaReady,
	       m_axis_tx_metadata_TDATA =>  out_meta,

	       s_axis_tx_status_TVALID => tx_status_valid,
	       s_axis_tx_status_TDATA => tx_status_data,
         s_axis_tx_status_TREADY => tx_status_ready,
	       
	       
               s_axis_rx_data_TVALID =>  packet_valid,
	       s_axis_rx_data_TREADY => packet_ready,
	       s_axis_rx_data_TDATA => packet_data,
	       s_axis_rx_data_TKEEP => (others => '1'),
	       s_axis_rx_data_TLAST => packet_last,

	       s_axis_rx_metadata_TVALID => '0',
	       s_axis_rx_metadata_TDATA => (others => '0')
	       	   
    
	       );
	       
  rstn <= not rst;                                    
  rst <= '0' after 400ns;
  rstX <= '0' after 400ns;
  clk <= not clk after 3.2ns;
  fclk <= not fclk after 3.2ns;
  clk200 <= not clk200 after 1.6ns;

  stim_event: process
    file eventfile : text is in "../../session-event-in.txt";
    variable evinline : line;
    variable evtype : std_logic_vector(15 downto 0);
    variable evdata : std_logic_Vector(87 downto 0);
    
  begin
    wait until clk'event and clk='1';
    
    
    if (rst='1') then
      
      waiting <= (others => '0');
      event_valid <= '0';
      
      openConnRespValid <= '0';

      
      tx_status_data <= (others => '0');
      
    else
    
       --tx_status_data(62) <= out_meta(23);
    
      count <= count + 1;
        

      if (openConnRespReady='1') then
        openConnRespValid<='0';
      end if;

	  if (openConnReqValid='1') then
	  	openConnRespValid<='1';
	  end if;

      if (event_ready='1') then
	event_valid <= '0';
      end if;

      if (waiting/=0) then
	waiting <= waiting-1;
	
      else
	
	if (event_ready='1' and  not endfile(eventfile)) then
	  
	  readline(eventfile, evinline);
	  hread(evinline, evtype);

	  if (evtype/=0) then
	    waiting <= evtype;
	  else
	    readline(eventfile, evinline);
	    hread(evinline, evdata);

	    event_valid <= '1';
	    event_data <= evdata;
	  end if;
	end if;
	
      end if;
    end if;
    
  end process;

  stim_data: process
    file datafile : text is in "../../session-data-in.txt";
    variable datinline : line;
    variable dattype : std_logic_vector(15 downto 0);
    variable datdata : std_logic_Vector(512+3 downto 0);
    
  begin
    wait until clk'event and clk='1';
    
    tx_status_valid <= out_meta_valid and metaReady;
    
    ticker <= ticker + 1;
    ticker(23 downto 16) <= "00001111";
    
    metaReady <= '0';
    
    cntReady <= cntReady +1;
    cntReady2 <= cntReady2 +1;
        
    if (cntReady<=3) then
    	metaReady <= '1';      	  	
    end if;
    
    
    if (cntReady=4) then
    	cntReady <= (others=>'0');
    end if;
    
    if (cntReady2=10) then
        cntReady2 <= (others=>'0');
    end if;
    
    if (rst='1') then
    
    	cntReady <= (others => '0');
      cntReady2 <= (others => '0');
      
      waiting2 <= (others => '0');
      packet_valid <= '0';
      packet_keep <= (others => '1');
      packet_last(0) <= '0';
      waitLast <= '0';
      
    else

      if (packet_ready='1') then
	packet_valid <= '0';
	packet_last(0) <= '0';
      end if;

      if (waiting2/=0) then
	waiting2 <= waiting2-1;
	
      else
	
	if ((packet_ready='1' or packet_valid='0') and not endfile(datafile)) then
	  	  
	  if (waitLast='0') then 	  	
	  	readline(datafile, datinline);
	  	hread(datinline, dattype);
	  end if;

	  if (dattype/=0 and waitLast='0') then
	    waiting2 <= dattype-1;
	  else
	    readline(datafile, datinline);
	    hread(datinline, datdata);

	    packet_valid <= '1';
	    waitLast <= not datdata(512);
	    
	    for X in 0 to 63 loop
	    	packet_data((63-X)*8+7 downto (63-X)*8) <= datdata(X*8+7 downto X*8);
	    end loop;
	       
	    packet_last(0) <= datdata(512);	    
	  end if;
	end if;
	
      end if;
    end if;
    
  end process;



end;