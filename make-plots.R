library(tidyverse)
library(ggdist)
library(distill)


# read data
x <- read_csv("ETFs.csv", col_types = cols(
  fund_symbol = col_character(),
  fund_extended_name = col_character(),
  fund_family = col_character(),
  inception_date = col_date(format = ""),
  category = col_character(),
  investment_strategy = col_character(),
  investment_type = col_character(),
  size_type = col_character(),
  currency = col_character(),
  fund_net_annual_expense_ratio = col_double(),
  category_net_annual_expense_ratio = col_double(),
  asset_stocks = col_double(),
  asset_bonds = col_double(),
  price_earnings_ratio = col_double(),
  price_book_ratio = col_double(),
  price_sales_ratio = col_double(),
  price_cashflow_ratio = col_double(),
  sector_basic_materials = col_double(),
  sector_consumer_cyclical = col_double(),
  sector_financial_services = col_double(),
  sector_real_estate = col_double(),
  sector_consumer_defensive = col_double(),
  sector_healthcare = col_double(),
  sector_utilities = col_double(),
  sector_communication_services = col_double(),
  sector_energy = col_double(),
  sector_industrials = col_double(),
  sector_technology = col_double(),
  credit_us_government = col_double(),
  credit_aaa = col_double(),
  credit_aa = col_double(),
  credit_a = col_double(),
  credit_bbb = col_double(),
  credit_bb = col_double(),
  credit_b = col_double(),
  credit_below_b = col_double(),
  credit_other_ratings = col_double(),
  net_asset_value = col_double(),
  fund_yield = col_double(),
  top10_holdings = col_character(),
  fund_return_ytd = col_double(),
  category_return_ytd = col_double(),
  fund_return_1month = col_double(),
  category_return_1month = col_double(),
  fund_return_3months = col_double(),
  category_return_3months = col_double(),
  fund_return_1year = col_double(),
  category_return_1year = col_double(),
  fund_return_3years = col_double(),
  category_return_3years = col_double(),
  fund_return_5years = col_double(),
  category_return_5years = col_double(),
  fund_return_10years = col_double(),
  category_return_10years = col_double(),
  fund_return_2019 = col_double(),
  category_return_2019 = col_logical(),
  fund_return_2018 = col_double(),
  category_return_2018 = col_logical(),
  fund_return_2017 = col_double(),
  category_return_2017 = col_logical(),
  fund_return_2016 = col_double(),
  category_return_2016 = col_logical(),
  fund_return_2015 = col_double(),
  category_return_2015 = col_double(),
  fund_return_2014 = col_double(),
  category_return_2014 = col_double(),
  fund_return_2013 = col_double(),
  category_return_2013 = col_double(),
  fund_return_2012 = col_double(),
  category_return_2012 = col_double(),
  fund_return_2011 = col_double(),
  category_return_2011 = col_double(),
  fund_return_2010 = col_double(),
  category_return_2010 = col_double(),
  years_up = col_double(),
  years_down = col_double(),
  fund_alpha_3years = col_double(),
  category_alpha_3years = col_double(),
  fund_alpha_5years = col_double(),
  category_alpha_5years = col_double(),
  fund_alpha_10years = col_double(),
  category_alpha_10years = col_double(),
  fund_beta_3years = col_double(),
  category_beta_3years = col_double(),
  fund_beta_5years = col_double(),
  category_beta_5years = col_double(),
  fund_beta_10years = col_double(),
  category_beta_10years = col_double(),
  fund_mean_annual_return_3years = col_double(),
  category_mean_annual_return_3years = col_double(),
  fund_mean_annual_return_5years = col_double(),
  category_mean_annual_return_5years = col_double(),
  fund_mean_annual_return_10years = col_double(),
  category_mean_annual_return_10years = col_double(),
  fund_r_squared_3years = col_double(),
  category_r_squared_3years = col_double(),
  fund_r_squared_5years = col_double(),
  category_r_squared_5years = col_double(),
  fund_r_squared_10years = col_double(),
  category_r_squared_10years = col_double(),
  fund_standard_deviation_3years = col_double(),
  category_standard_deviation_3years = col_double(),
  fund_standard_deviation_5years = col_double(),
  category_standard_deviation_5years = col_double(),
  fund_standard_deviation_10years = col_double(),
  category_standard_deviation_10years = col_double(),
  fund_sharpe_ratio_3years = col_double(),
  category_sharpe_ratio_3years = col_double(),
  fund_sharpe_ratio_5years = col_double(),
  category_sharpe_ratio_5years = col_double(),
  fund_sharpe_ratio_10years = col_double(),
  category_sharpe_ratio_10years = col_double(),
  fund_treynor_ratio_3years = col_double(),
  category_treynor_ratio_3years = col_double(),
  fund_treynor_ratio_5years = col_double(),
  category_treynor_ratio_5years = col_character(),
  fund_treynor_ratio_10years = col_double(),
  category_treynor_ratio_10years = col_double()
))


# top 5 fund managers graph
manager_plot <- x %>% 
  select(fund_symbol, fund_family, fund_return_1year) %>%
  group_by(fund_family) %>%
  summarize(avg_return = mean(fund_return_1year)) %>%
  arrange(desc(avg_return)) %>%
  head(5) %>%
  mutate(fund_family = fct_infreq(fund_family)) %>%
  mutate(fund_family = fct_rev(fund_family)) %>%
  ggplot(mapping = aes(x = fct_reorder(fund_family, avg_return), y = avg_return / 100)) +
  geom_col(fill = "LightBlue") +
  scale_y_continuous(labels = scales::percent) +
  theme_classic() +
  labs(title = "Top 5 ETF Managers",
       subtitle = "ARK ETF Trust was the best performing ETF fund, based on 1 year of performance",
       x = "Fund Family",
       y = "Average ETF Return (Percent)",
       caption = "Source: Yahoo Finance")

write_rds(manager_plot, "manager-plot.rds")

# yield plot
yield_plot <- x %>%
  select(fund_symbol, fund_yield, fund_return_1year) %>%
  ggplot(mapping = aes(x = fund_yield, y = fund_return_1year)) +
  geom_point(alpha = 0.2) +
  xlim(c(0, 20)) +
  geom_smooth(method = "lm", formula = y~x, se = FALSE) +
  theme_classic() +
  labs(title = "Fund Yield vs. Annual Return",
       subtitle = "Yield has a negative correlation with annual return.",
       x = "Fund Yield",
       y = "Annual Return (Percent)",
       caption = "Source: Yahoo Finance")

write_rds(yield_plot, "yield-plot.rds")

# sector data
sector_data <- x %>%
  select(fund_symbol, sector_basic_materials : sector_technology, fund_return_1year, fund_return_5years) %>%
  pivot_longer(names_to = "sector",
               values_to = "ratio",
               cols = c(-fund_symbol, -fund_return_1year, -fund_return_5years)) %>%
  mutate(sector = str_replace(sector, "sector_", "")) %>% # remove sector_ from the start of each row
  mutate(sector = str_replace(sector, "_", " ")) %>% # make the values more "word-like"
  mutate(sector = str_to_title(sector)) %>%
  filter(ratio >= 50) # only find ETFs with a majority in one sector

# sector short-term plot
sector_short_plot <- sector_data %>%
  ggplot(mapping = aes(fund_return_1year, sector)) +
  stat_slab() +
  coord_cartesian(xlim = c(-60, 100)) +
  geom_vline(xintercept = 0, color = "red") +
  geom_vline(xintercept = 10, color = "blue") +
  theme_classic() +
  labs(title = "Sectors vs. Annual Return",
       subtitle = "The technology sector performed the best over the past year.",
       x = "Annual Return",
       y = "Sector",
       caption = "Source: Yahoo Finance")

write_rds(sector_short_plot, "sector-short-plot.rds")

# sector long-term plot
sector_long_plot <- sector_data %>%
  drop_na(fund_return_5years) %>%
  ggplot(mapping = aes(fund_return_5years, sector)) +
  stat_slab() +
  coord_cartesian(xlim = c(-20, 30)) +
  geom_vline(xintercept = 0, color = "red") +
  geom_vline(xintercept = 10, color = "blue") +
  geom_text(aes(x = 10 , y = 0.7, label = "S&P 500")) +
  theme_classic() +
  labs(title = "Sectors vs. Average Annual Returns Over 5 Years",
       subtitle = "In the longterm, the technology sector performed the best, \nwhile the energy sector had negative returns.",
       x = "Annual Return",
       y = "Sector",
       caption = "Source: Yahoo Finance")

write_rds(sector_long_plot, "sector-long-plot.rds")


# investment type short-term plot
type_short_plot <- x %>%
  select(investment_type, fund_return_1year) %>%
  drop_na() %>%
  group_by(investment_type) %>%
  summarize(avg_return = mean(fund_return_1year)) %>%
  mutate(investment_type = fct_infreq(investment_type)) %>% #what does this row & the row below do?
  mutate(investment_type = fct_rev(investment_type)) %>%
  ggplot(mapping = aes(x = fct_reorder(investment_type, avg_return), y = avg_return)) +
  geom_col(fill = "LightBlue") +
  theme_classic() +
  labs(title = "Investment Type vs. Annual Returns",
       subtitle = "Riskier growth focused investments delivered high returns, \nwhile value oriented investments lost money.",
       x = "Investment Type",
       y = "Annual Return")

write_rds(type_short_plot, "type-short-plot.rds")

# investment type long-term plot
type_long_plot <- x %>%
  select(investment_type, fund_return_5years) %>%
  drop_na() %>%
  group_by(investment_type) %>%
  summarize(avg_return = mean(fund_return_5years)) %>%
  mutate(investment_type = fct_infreq(investment_type)) %>% #what does this row & the row below do?
  mutate(investment_type = fct_rev(investment_type)) %>%
  ggplot(mapping = aes(x = fct_reorder(investment_type, avg_return), y = avg_return)) +
  geom_col(fill = "LightBlue") +
  theme_classic() +
  labs(title = "Investment Type vs. Average Annual Returns Over 5 Years",
       subtitle = "In the long term, riskier growth focused investments delivered higher returns.",
       x = "Investment Type",
       y = "Average Annual Return")

write_rds(type_long_plot, "type-long-plot.rds")