Here is the code for mlflow.log_param / mlflow.log_metric code 

```python
def train_and_log(hidden_layer_sizes=(64,), learning_rate_init=0.001, batch_size=128, run_name=None):
    with mlflow.start_run(run_name=run_name):
        mlflow.log_param("hidden_layer_sizes", hidden_layer_sizes)
        mlflow.log_param("learning_rate_init", learning_rate_init)
        mlflow.log_param("batch_size", batch_size)

        model, acc, f1 = train_and_evaluate(hidden_layer_sizes, learning_rate_init, batch_size)

        mlflow.log_metric("accuracy", acc)
        mlflow.log_metric("f1_macro", f1)

        for epoch, (train_loss, val_acc) in enumerate(zip(model.loss_curve_, model.validation_scores_)):
            mlflow.log_metric("train_loss", train_loss, step=epoch)
            mlflow.log_metric("val_accuracy", val_acc, step=epoch)

        mlflow.set_tag("team", "data-science")
        mlflow.sklearn.log_model(model, name="model", serialization_format="cloudpickle")

        run_id = mlflow.active_run().info.run_id
        print(f"Logged run {run_id}  |  acc={acc:.4f}  f1={f1:.4f}")
        return run_id
```