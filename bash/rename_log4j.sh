#!/bin/bash
  
results=$(find / -name log4j*-2.*.jar -not -path "/mnt")
for i in $results; do
        mv $i $i.bak
done

new_results=$(find / -name log4j*-2.*.jar.bak -not -path "/mnt")
for i in $new_results; do
        echo $i
done
