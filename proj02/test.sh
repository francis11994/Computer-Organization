

#!/bin/bash
make test00
./test00 > ourtest00.txt
diff ourtest00.txt testResults/test00.txt
echo "done with test00"
make test01
./test01 > ourtest01.txt
diff ourtest01.txt testResults/test01.txt
echo "done with test01"
make test02
./test02 > ourtest02.txt
diff ourtest02.txt testResults/test02.txt
echo "done with test02
