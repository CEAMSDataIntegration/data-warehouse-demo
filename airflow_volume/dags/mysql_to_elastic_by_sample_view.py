from airflow import DAG
from airflow.operators.python_operator import PythonOperator
from datetime import datetime
from mysql_utils import extract_by_sample_view
from json_utils import transform_by_sample_view_json
from elastic_utils import load_to_elasticsearch, delete_index

default_args = {
    'owner': 'DL',
    'start_date': datetime(2023, 5, 25),
    'schedule_interval': '@daily'
}

index_name = 'by_sample_view'

dag = DAG('mysql_to_elastic_by_sample_view', default_args=default_args, catchup=False)

# Task 1: Extract patients from MySQL
extract_by_sample_view_task = PythonOperator(
    task_id='extract_by_sample_view',
    python_callable=extract_by_sample_view,
    dag=dag
)

# Task 2: Create JSON documents
transform_by_sample_view_json_task = PythonOperator(
    task_id='transform_by_sample_view_json',
    python_callable=transform_by_sample_view_json,
    op_kwargs={'rows': extract_by_sample_view_task.output},
    dag=dag
)

# Task 3: Import data into Elasticsearch
load_to_elasticsearch_task = PythonOperator(
    task_id='load_to_elasticsearch',
    python_callable=load_to_elasticsearch,
    op_kwargs={'rows_json': transform_by_sample_view_json_task.output, 'index_name':index_name},
    dag=dag
)

delete_index_task = PythonOperator(
    task_id='delete_index',
    python_callable=delete_index,
    op_kwargs={'index_name': index_name},
    dag=dag
)

# Define task dependencies
extract_by_sample_view_task >> transform_by_sample_view_json_task >> delete_index_task >> load_to_elasticsearch_task
