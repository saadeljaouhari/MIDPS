import sys
import pickle
from sklearn.feature_extraction.text import TfidfVectorizer
import numpy
import os

import json

# ignore all resource smaller than a given threshold
query_min_len=20

def check_sqli_attempt(file_path,model_path,vocabulary_path,verdict_file_path,address):

    # load the model from disk
    loaded_model = pickle.load(open(model_path, 'rb'))

    # load the vocabulary from disk
    vocabulary = pickle.load(open(vocabulary_path, 'rb'))

    # intializing the input vectorizer
    input_vectorizer = TfidfVectorizer(vocabulary=vocabulary)

    f = open(file_path,'r')
    lines = f.readlines()

    sql_attempt=False

    for line in lines:
        # checking that the line format is regular
        if len(line.split(' '))==6:
            split_line = line.split(' ')
            resource = line.split(' ')[3]
            if len(resource)<query_min_len:
                break
            vectorized_input = input_vectorizer.fit_transform([resource]).toarray()
            vectorized_input=vectorized_input.reshape(1,-1)
            predictions=loaded_model.predict(vectorized_input)
            # if the prediction value is 1 then we have a positive case`
            if predictions[0]==1:

                sql_attempt=True
                break

    return sql_attempt

if __name__=="__main__":

    file_path=sys.argv[1]

    model_path = sys.argv[2]

    vocabulary_path = sys.argv[3]

    verdict_folder_path='/tmp/logs/verdicts'

    frame_name=file_path.split('/')[-2]

    frame_folder_path='{}/{}'.format(verdict_folder_path,frame_name)

    address = file_path.split('/')[-1]

    verdict_file_path='{}/{}'.format(frame_folder_path,address)

    sql_attempt=check_sqli_attempt(file_path,model_path,vocabulary_path,verdict_file_path,address)

    if sql_attempt:
        if not os.path.exists(frame_folder_path):

            os.makedirs(frame_folder_path)

        with open(verdict_file_path,"a+") as f:
            f.write('{} - POSSIBLE SQL INJECTION ATTEMPT\n'.format(address))
