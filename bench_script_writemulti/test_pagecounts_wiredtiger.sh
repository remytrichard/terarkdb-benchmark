nohup dstat -tcm --output /home/panfengfeng/trace_log_2/in-memory/pagecounts/fillrandom_readrandom_mulit_wiredtiger_no_lsm_256_append 2 > nohup.out &

file=/data/publicdata/pagecounts/pagecounts-2015-12-views-ge-5
record_num=65187562
read_num=32000000
writebuffer=67108864
#cachesize=67108864
#cachesize=2147483648
cachesize=268435456
dirname=/mnt/datamemory

rm -rf $dirname/*

echo "####Now, running wiredtiger benchmark"
echo 3 > /proc/sys/vm/drop_caches
free -m
date
../db_pagecounts_wiredtiger --benchmarks=fillrandom --num=$record_num --reads=$read_num --db=$dirname --use_lsm=0 --cache_size=$cachesize --resource_data=$file
free -m
date
du -s -b $dirname
#cachesize=`du -s -b -b $dirname | awk '{print $1}'`
echo "####wiredtiger benchmark finish"
free -m

echo "####Now, running wiredtiger benchmark"
echo 3 > /proc/sys/vm/drop_caches
free -m
date
../db_pagecounts_wiredtiger --benchmarks=readrandom --num=$record_num --reads=$read_num --db=$dirname --use_lsm=0 --cache_size=$cachesize --use_existing_db=1 --resource_data=$file
free -m
date
echo "####wiredtiger benchmark finish"
du -s -b $dirname
#cachesize=`du -s -b -b $dirname | awk '{print $1}'`

echo "####Now, running wiredtiger benchmark"
echo 3 > /proc/sys/vm/drop_caches
free -m
date
../db_pagecounts_wiredtiger --benchmarks=readrandom --num=$record_num --reads=$read_num --db=$dirname --use_lsm=0 --cache_size=$cachesize --use_existing_db=1 --threads=8 --resource_data=$file
free -m
date
echo "####wiredtiger benchmark finish"
du -s -b $dirname
#
echo "####Now, running wiredtiger benchmark"
echo 3 > /proc/sys/vm/drop_caches
free -m
date
../db_pagecounts_wiredtiger --benchmarks=readrandom --num=$record_num --reads=$read_num --db=$dirname --use_lsm=0 --cache_size=$cachesize --use_existing_db=1 --threads=16 --resource_data=$file
free -m
date
echo "####wiredtiger benchmark finish"
du -s -b $dirname

dstatpid=`ps aux | grep dstat | awk '{if($0 !~ "grep"){print $2}}'`
for i in $dstatpid
do
        kill -9 $i
done

