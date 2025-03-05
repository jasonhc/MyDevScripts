#!/usr/bin/env bash

# 让指定的类实现 Serializable接口; 从标准输入中读取所有类名, 每行一个类名; 类名要包含完整包名, 内嵌类写成"A$B", 比如:
# com.stv.deskplatform.logic.model.user.QueryMember$Entry
# Usage: cat <file containing class name> | make-xxx.sh

source ~/tools/launcher-scripts-env.sh

#dryRun="echo"
PROJECTS="tv-deskplatform tv-template-desktop tv-desktop-library tv-newvideo-desktop tv-app-desktop"

function makeClassSerializable() {
  fullClassName=$1

  packageName=${fullClassName%.*}
  classPath=${packageName//.//}
  className=${fullClassName##*.}
  mClassName=${className%\$*}
  internalClassName=${className##*\$}
  if [ $internalClassName ]; then
    className=$internalClassName
  else
    className=$mClassName
  fi

  for project in ${PROJECTS[@]}; do
    classFile=$projectRootPath/$project/src/main/java/$classPath/$mClassName.java
    if [ -f $classFile ]; then
      searchSerializable=$(egrep "class\s+$className\s+implements\s+Serializable" $classFile)
      if [ ! "$searchSerializable" ]; then
        $dryRun sed -E -i '' -e "s/class[[:space:]]+$className(.+)\{/class $className\1implements Serializable {/" $classFile
        importSerializable=$(egrep "^import\s+java\.io\.Serializable;" $classFile)
        if [ ! "$importSerializable" ]; then
          $dryRun sed -E -i '' -e '/^package(.+)/a\
\
import java.io.Serializable;\
' $classFile
        fi
      fi

      break
    fi
  done

  if [ ! -f $classFile ]; then
    echo "!!! class $mClassName not found in project"
  fi
}

for class in $(</dev/stdin); do
  echo "## class=$class"
  makeClassSerializable $class
done
