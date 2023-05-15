import math

log_file = 'fs_logs'
data_dict={}

def compute_req_length_array(log_file):
#log_format  main  '$remote_addr - $remote_user [$time_local] "$request"
            #'$status $body_bytes_sent "$http_referer" '
            #'"$http_user_agent" "$http_x_forwarded_for"'
    result=[]
    f = open(log_file)
    referer = ''
    resource = ''
    for line in f.readlines():
        line = line.split(' ')
        request_resource = line[6]
        result.append(len(request_resource))

    return result

def compute_mean(data):

    return sum(data) / len(data)

def compute_variance(data,mean):

    squared_diffs = [(x - mean) ** 2 for x in data]

    variance = sum(squared_diffs) / (len(squared_diffs))

    return variance

def compute_standard_deviation(data):

    mean = compute_mean(data)

    variance = compute_variance(data,mean)

    stddev = math.sqrt(variance)

    return stddev

def compute_probability(value,variance,mean):

    return (variance)/((value-mean)**2)


if __name__ == '__main__':
    requests_length = compute_req_length_array(log_file)
    print(sorted(requests_length))
    mean = compute_mean(requests_length[5:])
    variance = compute_variance(requests_length,mean)
    probability = compute_probability(77,variance,mean)

    print(probability)

    if probability < 1:
        print("sus")
