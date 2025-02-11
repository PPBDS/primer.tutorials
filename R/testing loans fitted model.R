library(learnr)
library(tutorial.helpers)
library(gt)

# DK: Add questions for loading up openintro and ranger.

library(tidyverse)
library(openintro)
library(tidymodels)
library(ranger)
library(gtsummary)
library(equatiomatic)
library(marginaleffects)


loans <- read_csv("https://raw.githubusercontent.com/vincentarelbundock/Rdatasets/refs/heads/master/csv/openintro/loans_full_schema.csv", show_col_types = FALSE)


  #overfitted model

  # Set seed for reproducibility
  set.seed(5)

# Split data into training and testing
loans_split <- initial_split(loans, prop = 0.50)
loans_train <- training(loans_split)
loans_test <- testing(loans_split)

# Define an overfitted random forest model
fit_loans_model <- rand_forest(
  mode = "regression",
  engine = "ranger",
  mtry = 1,
  trees = 1e4,    # Large number of trees for overfitting
  min_n = 5       # Small minimum node size for overfitting
)

# Train the model
fit_loans <- fit_loans_model %>%
  fit(interest_rate ~  paid_interest + 
        paid_principal + inquiries_last_12m + term + total_debit_limit + total_credit_limit, data = loans_train)


# Generate predictions for training and testing sets
loans_train_res <- predict(fit_loans, new_data = loans_train) %>%
  bind_cols(loans_train %>% select(interest_rate))

loans_test_res <- predict(fit_loans, new_data = loans_test) %>%
  bind_cols(loans_test %>% select(interest_rate))

# Define the metric set
metrics <- metric_set(rmse, rsq, mae)

# Evaluate metrics for training and testing sets
train_metrics <- metrics(loans_train_res, truth = interest_rate, estimate = .pred) %>%
  mutate(Set = "Training")

test_metrics <- metrics(loans_test_res, truth = interest_rate, estimate = .pred) %>%
  mutate(Set = "Test")

# Combine metrics for comparison
comparison_metrics <- bind_rows(train_metrics, test_metrics)

# Print the results
print(comparison_metrics)



#underfitted model

# Set seed for reproducibility
set.seed(8)


# Split data into training and testing
loans_split <- initial_split(loans, prop = 0.90)
loans_train <- training(loans_split)
loans_test <- testing(loans_split)



fit_loans_model <- rand_forest(
  mode = "regression",
  engine = "ranger",
  mtry = 1,
  trees = 14,    # Large number of trees for overfitting
  min_n = 80      # Small minimum node size for overfitting
)







##plot for rsq
# Load necessary libraries
library(tidymodels)
library(ggplot2)
library(yardstick)  # For rsq function
library(dplyr)  # For data manipulation

# Initialize a vector to store R² values
results <- data.frame(trees = integer(), mtry = integer(), train_rsq = numeric(), test_rsq = numeric())

# Loop through different numbers of trees and mtry values
for (num_trees in c(1, 25, 50, 75, 100, 200, 300, 400, 500)) {
  for (num_mtry in c(2, 4)) {
    
    # Define the model with the current number of trees and mtry
    fit_loans_model <- rand_forest(
      mode = "regression",
      engine = "ranger",
      mtry = num_mtry,
      trees = num_trees,
      min_n = 4
    )
    
    # Fit the model using the provided formula
    fit_loans <- fit_loans_model |> fit(interest_rate ~ sub_grade + grade + paid_interest + paid_principal, 
                                        data = loans_train)
    
    # Make predictions on the training and test datasets
    train_predictions <- predict(fit_loans, new_data = loans_train) %>% 
      bind_cols(loans_train)  # Bind predictions with actual data
    test_predictions <- predict(fit_loans, new_data = loans_test) %>% 
      bind_cols(loans_test)  # Bind predictions with actual data
    
    # Calculate R² for both train and test
    train_rsq <- rsq(train_predictions, truth = interest_rate, estimate = .pred)$.estimate  # Replace `interest_rate` with your target variable
    test_rsq <- rsq(test_predictions, truth = interest_rate, estimate = .pred)$.estimate  # Replace `interest_rate` with your target variable
    
    # Store the results in the results dataframe
    results <- results %>%
      add_row(trees = num_trees, mtry = num_mtry, train_rsq = train_rsq, test_rsq = test_rsq)
  }
}

# Plot the R² values
ggplot(results, aes(x = trees, color = factor(mtry), linetype = ifelse(trees == max(trees), "Test", "Train"))) +
  geom_line(aes(y = train_rsq), size = 1.2) +  # Train line
  geom_line(aes(y = test_rsq), size = 1.2) +   # Test line
  labs(title = "R² for Different Numbers of Trees and mtry Values",
       x = "Number of Trees",
       y = "R²",
       color = "mtry Values",
       linetype = "Dataset") +
  theme_minimal() +
  scale_color_manual(name = "mtry Values", values = rainbow(length(unique(results$mtry)))) +
  scale_linetype_manual(name = "Dataset", values = c("Train" = "dotted", "Test" = "solid"))




###Extracting variabel importance
fit_loans_model <- rand_forest(
  mode = "regression",
  engine = "ranger",
  mtry = 6,  # Example value
  trees = 500,
  min_n = 4
) %>%
  set_engine("ranger", importance = "permutation") %>%  # Add this line
  fit(interest_rate ~ ., data = loans_train)
importance <- fit_loans_model$fit$variable.importance
importance <- as.data.frame(importance) %>%
  rownames_to_column(var = "Variable") %>%
  arrange(desc(importance))

print(importance)













