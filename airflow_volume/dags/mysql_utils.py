from airflow.hooks.mysql_hook import MySqlHook

def extract_by_sample_type_view():
    connection_id = 'BIOBANK_DB'
    mysql_hook = MySqlHook(mysql_conn_id=connection_id)

    # Example query to execute. Replace this with your own SQL query.
    query = "SELECT project_link_id, sdb_id, pssid, pssid_mask, sample_type, barcodes, total_volume, samples_count, project_name, pi_name, project_group, site_name FROM by_sample_type_view;"

    # Executing the query and fetching results
    results = mysql_hook.get_records(query)
    return results

def extract_by_sample_view():
    connection_id = 'BIOBANK_DB'
    mysql_hook = MySqlHook(mysql_conn_id=connection_id)

    # Example query to execute. Replace this with your own SQL query.
    query = "SELECT project_link_id, sdb_id, pssid, pssid_mask, sample_type, barcode, volume, created_at, project_name, pi_name, project_group, site_name FROM by_sample_view;"

    # Executing the query and fetching results
    results = mysql_hook.get_records(query)
    return results