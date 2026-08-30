```python
def train_and_log(
    learning_rate=0.001,
    batch_size=64,
    hidden_layer_sizes=(128,),
    epochs=10,
    run_name=None
):

    with mlflow.start_run(run_name=run_name):

        # -------------------------
        # Log hyperparameters
        # -------------------------

        mlflow.log_param("learning_rate", learning_rate)
        mlflow.log_param("batch_size", batch_size)
        mlflow.log_param("hidden_layer_sizes", str(hidden_layer_sizes))
        mlflow.log_param("epochs", epochs)

        # -------------------------
        # Create MLP
        # -------------------------

        model = MLPClassifier(
            hidden_layer_sizes=hidden_layer_sizes,
            learning_rate_init=learning_rate,
            batch_size=batch_size,
            max_iter=1,
            warm_start=True,
            random_state=42
        )

        # -------------------------
        # Train one epoch at a time
        # -------------------------

        for epoch in range(epochs):

            model.fit(X_train, y_train)

            # Training loss
            train_loss = model.loss_

            # Predictions
            train_preds = model.predict(X_train)
            val_preds = model.predict(X_val)

            # Probabilities for validation loss
            val_probs = model.predict_proba(X_val)

            # Accuracy
            train_acc = accuracy_score(y_train, train_preds)
            val_acc = accuracy_score(y_val, val_preds)

            # Validation loss
            val_loss = log_loss(y_val, val_probs)

            # -------------------------
            # Log epoch metrics
            # -------------------------

            mlflow.log_metric(
                "train_loss",
                train_loss,
                step=epoch
            )

            mlflow.log_metric(
                "val_loss",
                val_loss,
                step=epoch
            )

            mlflow.log_metric(
                "train_accuracy",
                train_acc,
                step=epoch
            )

            mlflow.log_metric(
                "val_accuracy",
                val_acc,
                step=epoch
            )

            print(
                f"Epoch {epoch + 1}/{epochs} | "
                f"train_loss={train_loss:.4f} | "
                f"val_loss={val_loss:.4f} | "
                f"train_acc={train_acc:.4f} | "
                f"val_acc={val_acc:.4f}"
            )

        # -------------------------
        # Final test accuracy
        # -------------------------

        test_preds = model.predict(X_test)
        test_acc = accuracy_score(y_test, test_preds)

        mlflow.log_metric("test_accuracy", test_acc)

        run_id = mlflow.active_run().info.run_id

        print(
            f"\nRun: {run_id}"
            f"\nFinal test accuracy: {test_acc:.4f}"
        )

        return run_id
```