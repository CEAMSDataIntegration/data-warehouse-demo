from datetime import datetime

def transform_by_sample_type_view_json(rows):
    rows_json = []
    for row in rows:
        row_json = {
            'project_link_id':row[0],
            'sdb_id':row[1],
            'pssid':row[2],
            'pssid_mask':row[3],
            'sample_type':row[4],
            'barcodes':row[5],
            'total_volume':row[6],
            'samples_count':row[7],
            'project_name':row[8],
            'pi_name':row[9],
            'project_group':row[10],
            'site_name':row[11]
        }
        rows_json.append(row_json)


    return rows_json

def transform_by_subject_view_json(rows):
    subjects = []
    for row in rows:
        # Check if an object with the specified ID exists in the list
        project_link_id = row[0]
        subject = next((subject for subject in subjects if subject['project_link_id'] == project_link_id), None)
        
        # create subject object if not found
        if subject is None:
            subject = {
                'project_link_id':row[0],
                'sdb_id':row[1],
                'pssid':row[2],
                'pssid_mask':row[3],
                'samples':[],
                'project_name':row[8],
                'pi_name':row[9],
                'site_name':row[11]
            }
            subjects.append(subject)
        
        # Add sample to subject
        subject['samples'].append({
            'sample_type':row[4],
            'barcode':row[5],
            'volume':float(row[6]),
            'created_at':convert_date(row[7]),
        })

    return subjects


def transform_by_sample_view_json(rows):
    rows_json = []
    for row in rows:
        row_json = {
            'project_link_id':row[0],
            'sdb_id':row[1],
            'pssid':row[2],
            'pssid_mask':row[3],
            'sample_type':row[4],
            'barcode':row[5],
            'volume':float(row[6]),
            'created_at':convert_date(row[7]),
            'project_name':row[8],
            'pi_name':row[9],
            'project_group':row[10],
            'site_name':row[11]
        }
        rows_json.append(row_json)

    return rows_json

def convert_date(biobank_date):
    # Parse the input date using the datetime module
    date_obj = datetime.strptime(biobank_date, "%m/%d/%Y")

    # Format the date in YYYY/MM/DD format
    output_date = date_obj.strftime("%Y/%m/%d")
    return output_date