from airflow.hooks.base_hook import BaseHook
from elasticsearch import Elasticsearch

def load_to_elasticsearch(rows_json, index_name):
    connection_id = "ELASTIC"
    connection = BaseHook.get_connection(connection_id)

    es = Elasticsearch([{'host': connection.host, 'port':connection.port, 'scheme':connection.schema}])

    for index, row_json in enumerate(rows_json):
        es.options(
                basic_auth=(connection.login, connection.password)
            ).index(index=index_name, id=index, document=row_json)

    return True

def delete_index(index_name):
    connection_id = "ELASTIC"
    connection = BaseHook.get_connection(connection_id)

    es = Elasticsearch([{'host': connection.host, 'port':connection.port, 'scheme':connection.schema}])
    if not es.options(
                basic_auth=(connection.login, connection.password)
            ).indices.exists(index=index_name):
        print(f"The index '{index_name}' does not exist.")
        return False
    # You can choose to handle this case according to your requirements.
    else:
        try:
            # Attempt to delete the index
            es.options(
                basic_auth=(connection.login, connection.password)
            ).indices.delete(index=index_name)
            print(f"The index '{index_name}' has been deleted successfully.")
        except NotFoundError:
            print(f"The index '{index_name}' does not exist.")
            return False

    return True
