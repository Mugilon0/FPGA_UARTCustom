library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity UART_calculater is 
    port(
        clk        : in  std_logic;
        reset      : in  std_logic;
        add_num    : in  std_logic_vector(7 downto 0);
        calced_num : out unsigned(3 downto 0)
    );
end UART_calculater;


architecture Behavioral of UART_calculater is 
    signal accumulated_value : unsigned(3 downto 0) := (others => '0');

begin
    process(clk)
        variable next_value : unsigned(3 downto 0);
    begin
        if rising_edge(clk) then
            if reset = '1' then
                accumulated_value <= (others => '0');
            else
                if add_num >= "00110000" and add_num <= "00111001" then -- 0~9の入力だったら
                    -- まず加算
                    if accumulated_value + unsigned(add_num(3 downto 0)) >= 10 then
                        -- 10を超えたら10を引く
                        next_value := accumulated_value + unsigned(add_num(3 downto 0)) - 10;
                    else
                        -- そのまま
                        next_value := accumulated_value + unsigned(add_num(3 downto 0));
                    end if;
                    accumulated_value <= next_value;
                end if;
            end if;
        end if;
    end process;

    calced_num <= accumulated_value;
    
end Behavioral;


















-- library ieee;
-- use ieee.std_logic_1164.all;
-- use ieee.numeric_std.all;


-- entity UART_calculate is 
--     port(
--         clk        : in  std_logic;
--         reset      : in  std_logic;                     -- リセット追加
--         add_num    : in  std_logic_vector(7 downto 0);
--         calced_num : out unsigned(3 downto 0)
--     );
-- end UART_calculate;


-- architecture Behavioral of UART_calculate is

--     signal accumulated_value : unsigned(3 downto 0) := (others => '0');

-- begin

--     process(clk)
--         variable temp_sum : unsigned(4 downto 0);  -- 5ビット（桁上がり検出用）
--     begin
--         if rising_edge(clk) then
--             if reset = '1' then
--                 accumulated_value <= (others => '0');
--             else
--                 -- ASCII '0'-'9' (0x30-0x39) が来たら加算
--                 if add_num >= "00110000" and add_num <= "00111001" then
--                     -- add_numの下位4ビットが数値（0-9）
--                     -- 5ビットで計算して桁上がりを検出
--                     temp_sum := ('0' & accumulated_value) + ('0' & unsigned(add_num(3 downto 0)));
                    
--                     -- 1桁目のみを保存（下位4ビット）
--                     -- 10以上なら10で割った余り = mod 10
--                     if temp_sum >= 10 then
--                         accumulated_value <= temp_sum - 10;  -- 10を引く = mod 10
--                     else
--                         accumulated_value <= temp_sum(3 downto 0);
--                     end if;
--                 end if;
--             end if;
--         end if;
--     end process;

--     -- 出力
--     calced_num <= accumulated_value;

-- end Behavioral;