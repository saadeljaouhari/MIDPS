import json

log_file = 'test_logs'
data_dict={}

def correlate(log_file):
#log_format  main  '$remote_addr - $remote_user [$time_local] "$request"
            #'$status $body_bytes_sent "$http_referer" '
            #'"$http_user_agent" "$http_x_forwarded_for"'
    line_no = 0
    f = open(log_file)
    referer = ''
    resource = ''
    for line in f.readlines():
        line = line.rstrip()
        if line_no % 2 == 0:
            resource = line
        if line_no % 2 == 1:
            referer = line

            if referer not in data_dict.keys():
                data_dict[referer]=[resource]
            else:
                if resource not in data_dict[referer]:
                    data_dict[referer].append(resource)

        line_no = line_no + 1

correlate(log_file)
print(json.dumps(data_dict,indent=4))
