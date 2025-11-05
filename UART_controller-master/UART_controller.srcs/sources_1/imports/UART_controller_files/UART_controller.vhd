library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity UART_controller is

    port(
        clk              : in  std_logic;
        reset            : in  std_logic;
        tx_enable        : in  std_logic;

        data_in          : in  std_logic_vector (7 downto 0);
        data_out         : out std_logic_vector (7 downto 0);

        rx               : in  std_logic;
        tx               : out std_logic;
        
        cathodes : out std_logic_vector (6 downto 0);
        anodes : out std_logic_vector (3 downto 0)
        );
end UART_controller;


architecture Behavioral of UART_controller is

    component button_debounce
        port(
            clk        : in  std_logic;
            reset      : in  std_logic;
            button_in  : in  std_logic;
            button_out : out std_logic
            );
    end component;


    component UART
        port(
            clk            : in  std_logic;
            reset          : in  std_logic;
            tx_start       : in  std_logic;

            data_in        : in  std_logic_vector (7 downto 0);
            data_out       : out std_logic_vector (7 downto 0);

            rx             : in  std_logic;
            tx             : out std_logic
            );
    end component;

    signal button_pressed : std_logic;
    signal rx_data : std_logic_vector(7 downto 0);
    

    -- signal dummy : std_logic_vector(7 downto 0); 11/5


begin
    -- sseg_cathodes <= data_out(6 downto 0);
    anodes <= "1110";
    -- sseg_cathodes <= dummy(6 downto 0);
    data_out<= rx_data;



    tx_button_controller: button_debounce
    port map(
            clk            => clk,
            reset          => reset,
            button_in      => tx_enable,
            button_out     => button_pressed
            );

    UART_transceiver: UART
    port map(
            clk            => clk,
            reset          => reset,
            tx_start       => button_pressed,
            data_in        => data_in,
            data_out       => rx_data,
            rx             => rx,
            tx             => tx
            );


    decoder_proc : process(rx_data) --0011
    
    begin 
        case rx_data is 
            when "00110000" => cathodes <= "1000000"; -- 0
            when "00110001" => cathodes <= "1111001"; -- 1
            when "00110010" => cathodes <= "0100100"; -- 2
            when "00110011" => cathodes <= "0110000"; -- 3
            when "00110100" => cathodes <= "0011001"; -- 4
            when "00110101" => cathodes <= "0010010"; -- 5
            when "00110110" => cathodes <= "0000010"; -- 6
            when "00110111" => cathodes <= "1111000"; -- 7
            when "00111000" => cathodes <= "0000000"; -- 8
            when "00111001" => cathodes <= "0010000"; -- 9
            when others => cathodes <= "1111111";
        end case;
    end process;
end Behavioral;







-- 前回動かしてデータの送信過程がうまくいっていなかったスクリプト


-- library ieee;
-- use ieee.std_logic_1164.all;
-- use ieee.numeric_std.all;


-- entity UART_controller is

--     port(
--         clk              : in  std_logic;
--         reset            : in  std_logic;
--         tx_enable        : in  std_logic;

--         data_in          : in  std_logic_vector (7 downto 0);
--         data_out         : inout std_logic_vector (7 downto 0);

--         rx               : in  std_logic;
--         tx               : out std_logic;

--         --  10/09
--         sseg_cathodes : out std_logic_vector (6 downto 0);
--         sseg_anodes : out std_logic_vector (3 downto 0)
--         );
-- end UART_controller;


-- architecture Behavioral of UART_controller is

--     component button_debounce
--         port(
--             clk        : in  std_logic;
--             reset      : in  std_logic;
--             button_in  : in  std_logic;
--             button_out : out std_logic
--             );
--     end component;


--     component UART
--         port(
--             clk            : in  std_logic;
--             reset          : in  std_logic;
--             tx_start       : in  std_logic;

--             data_in        : in  std_logic_vector (7 downto 0);
--             data_out       : inout std_logic_vector (7 downto 0);

--             rx             : in  std_logic;
--             tx             : out std_logic
--             );
--     end component;


--     signal button_pressed : std_logic;
--     signal inputed_num : unsigned(3 downto 0);
--     signal uart_data_s : std_logic_vector(7 downto 0);


-- begin

--     tx_button_controller: button_debounce
--     port map(
--             clk            => clk,
--             reset          => reset,
--             button_in      => tx_enable,
--             button_out     => button_pressed
--             );


--     UART_transceiver: UART
--     port map( -- 部品の端子(UART.vhdのentity)とそれを使う親モジュール側の配線(UART_controller.vhdのsignal)
--             clk            => clk,
--             reset          => reset,
--             tx_start       => button_pressed,
--             data_in        => data_in,
--             data_out       => data_out, 
--             rx             => rx,
--             tx             => tx
--             );
    

--     ascii_to_num_proc : process(uart_data_s) 
--     begin
--         if uart_data_s(7 downto 4) = "0011" then 
            
--             inputed_num <= unsigned(uart_data_s(3 downto 0));
--         else 
--             inputed_num <= (others => '0');
--         end if;
--     end process;



--     --     inputed_num <= unsigned(data_out(3 downto 0)) when data_out(7 downto 4) = "0011" else (others => '0');



--     -- 以下10/09 ---
--     decoder_proc : process(inputed_num) 
--     begin 
--         case inputed_num is 
--             when "0000" => sseg_cathodes <= "1000000"; -- 0
--             when "0001" => sseg_cathodes <= "1111001"; -- 1
--             when "0010" => sseg_cathodes <= "0100100"; -- 2
--             when "0011" => sseg_cathodes <= "0110000"; -- 3
--             when "0100" => sseg_cathodes <= "0011001"; -- 4
--             when "0101" => sseg_cathodes <= "0010010"; -- 5
--             when "0110" => sseg_cathodes <= "0000010"; -- 6
--             when "0111" => sseg_cathodes <= "1111000"; -- 7
--             when "1000" => sseg_cathodes <= "0000000"; -- 8
--             when "1001" => sseg_cathodes <= "0010000"; -- 9
--             when others => sseg_cathodes <= "1111111";
--         end case;
--     end process;

--     --sseg_anodes <= "1110" -- 右だけ光らせよう

        

-- end Behavioral;
