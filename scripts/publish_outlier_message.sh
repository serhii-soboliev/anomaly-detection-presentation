export TOPIC_ID=incoming-topic
gcloud pubsub topics publish ${TOPIC_ID} --message \
"{\"subscriberId\": \"00000000000000011\",  \
\"srcIP\": \"12.0.9.4\", \
\"dstIP\": \"12.0.1.3\", \
\"srcPort\": 5000, \
\"dstPort\": 3000, \
\"txBytes\": 28550000, \
\"rxBytes\": 40000, \
\"startTime\": 1570276550, \
\"endTime\": 1570276550, \
\"tcpFlag\": 0, \
\"protocolName\": \"tcp\", \
\"protocolNumber\": 0}"