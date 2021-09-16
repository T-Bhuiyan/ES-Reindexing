#! /usr/bin/bash
# redirect stdout/stderr to a file
exec > log.txt
# read -p "Elasticsearch IP: " ES_HOST
# read -p "Elasticsearch Port: " ES_PORT
# read -p "Index Source: " INDEX_NAME_SOURCE
# read -p "Index Destination: " INDEX_NAME_DESTINATION
# read -p "Customer ID: " CUSTOMER_ID
# read -p "Since: " SINCE_TIME
# read -p "Until: " UNTIL_TIME

while test $# -gt 0; do
           case "$1" in
                -host)
                    shift
                    ES_HOST=$1
                    shift
                    ;;
                -port)
                    shift
                    ES_PORT=$1
                    shift
                    ;;
                -customer)
                    shift
                    CUSTOMER_ID=$1
                    shift
                    ;;
                -source)
                    shift
                    INDEX_NAME_SOURCE=$1
                    shift
                    ;;
                -destination)
                    shift
                    INDEX_NAME_DESTINATION=$1
                    shift
                    ;;
                -since)
                    shift
                    SINCE_TIME=$1
                    shift
                    ;;
                -until)
                    shift
                    UNTIL_TIME=$1
                    shift
                    ;;
                *)
                   echo "$1 is not a recognized flag!"
                   return 1;
                   ;;
          esac
  done  

  # echo "First argument : $ES_HOST";
  # echo "Second argument : $ES_PORT";
  # echo "Third argument : $CUSTOMER_ID";
  # echo "Fourth argument : $INDEX_NAME_SOURCE";
  # echo "Fifth argument : $INDEX_NAME_DESTINATION";
  # echo "Sixth argument : $SINCE_TIME";
  # echo "Seventh argument : $UNTIL_TIME";

CREATE_INDEX_URL="http://${ES_HOST}:${ES_PORT}/$INDEX_NAME_DESTINATION"
REINDEX_ENDPOINT="http://${ES_HOST}:${ES_PORT}/_reindex"

#Create_New_Index
curl -XPUT $CREATE_INDEX_URL -d "@/put_json_body.json" 

printf "\n"

# curl -XPOST $REINDEX_ENDPOINT -H 'Content-Type: application/json' -d' 
#     {
#       "source": {
#         "index": "'"$INDEX_NAME_SOURCE"'"
#       },
#       "dest": {
#         "index": "'"$INDEX_NAME_DESTINATION"'"
#       }
#     }
#     '

#Reindex
curl -XPOST $REINDEX_ENDPOINT -H 'Content-Type: application/json' -d' 
    {
        "source": {
          "index": "'"$INDEX_NAME_SOURCE"'",
          "query": { 
            "bool": { 
              "filter": [
                { "term":  { "ip.keyword": "'"$CUSTOMER_ID"'"  }},
                  { "range": { "@timestamp": { "gte": "'"$SINCE_TIME"'", "lte": "'"$UNTIL_TIME"'" }}}  
              ]
             }
          }
        },
        "dest": {
          "index": "'"$INDEX_NAME_DESTINATION"'"
        }
    }
    '




printf "\n"

# SEARCH_URL="http://${ES_HOST}:${ES_PORT}/${INDEX_NAME_DESTINATION}/_search"
# curl -XGET $SEARCH_URL

printf "\n"