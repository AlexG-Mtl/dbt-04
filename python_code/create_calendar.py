import pandas as pd

# Define the start and end date for your calendar
start_date = '2018-01-01'
end_date = '2024-12-31'

# Generate a date range using pandas
date_range = pd.date_range(start=start_date, end=end_date)

# Create a DataFrame with calendar attributes
calendar_df = pd.DataFrame({
    'date': date_range,
    'year': date_range.year,
    'quarter': date_range.quarter,
    'month': date_range.month,
    'month_name': date_range.strftime('%B'),
    'day': date_range.day,
    'day_of_week': date_range.dayofweek,
    'day_of_week_name': date_range.strftime('%A'),
    'week_of_year': date_range.isocalendar().week,
    'is_weekend': date_range.dayofweek >= 5
})

# Save the DataFrame to a CSV file
calendar_df.to_csv(r'C:\LAB\Surf_202409\dbt-04\ag7\seeds\calendar.csv', index=False)

print('Calendar CSV file created successfully.')
