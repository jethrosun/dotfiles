#!/bin/bash

LEETCODE_URL=https://leetcode.com/problems/
LEETCODE_NEW_URL=https://leetcode.com/problems/
LEETCODE_OLD_URL=https://oj.leetcode.com/problems/


function get_question_slug()
{
    QUESTION_TITLE_SLUG=${1#${LEETCODE_URL}}
    QUESTION_TITLE_SLUG=$(echo $QUESTION_TITLE_SLUG | sed 's/\/.*//g') # remove the needless url path
}

function query_problem()
{
    TMP_JSON_FILE=tmp.json

    curl -s "https://leetcode.com/graphql?query=query%20getQuestionDetail(%24titleSlug%3A%20String!)%20%7B%0A%20%20isCurrentUserAuthenticated%0A%20%20question(titleSlug%3A%20%24titleSlug)%20%7B%0A%20%20%20%20questionId%0A%20%20%20%20questionFrontendId%0A%20%20%20%20questionTitle%0A%20%20%20%20translatedTitle%0A%20%20%20%20questionTitleSlug%0A%20%20%20%20content%0A%20%20%20%20translatedContent%0A%20%20%20%20difficulty%0A%20%20%20%20stats%0A%20%20%20%20contributors%0A%20%20%20%20similarQuestions%0A%20%20%20%20discussUrl%0A%20%20%20%20mysqlSchemas%0A%20%20%20%20randomQuestionUrl%0A%20%20%20%20sessionId%0A%20%20%20%20categoryTitle%0A%20%20%20%20submitUrl%0A%20%20%20%20interpretUrl%0A%20%20%20%20codeDefinition%0A%20%20%20%20sampleTestCase%0A%20%20%20%20enableTestMode%0A%20%20%20%20metaData%0A%20%20%20%20enableRunCode%0A%20%20%20%20enableSubmit%0A%20%20%20%20judgerAvailable%0A%20%20%20%20infoVerified%0A%20%20%20%20envInfo%0A%20%20%20%20urlManager%0A%20%20%20%20article%0A%20%20%20%20questionDetailUrl%0A%20%20%20%20discussCategoryId%0A%20%20%20%20discussSolutionCategoryId%0A%20%20%20%20libraryUrl%0A%20%20%20%20companyTags%20%7B%0A%20%20%20%20%20%20name%0A%20%20%20%20%20%20slug%0A%20%20%20%20%20%20translatedName%0A%20%20%20%20%7D%0A%20%20%20%20topicTags%20%7B%0A%20%20%20%20%20%20name%0A%20%20%20%20%20%20slug%0A%20%20%20%20%20%20translatedName%0A%20%20%20%20%7D%0A%20%20%7D%0A%20%20interviewed%20%7B%0A%20%20%20%20interviewedUrl%0A%20%20%20%20companies%20%7B%0A%20%20%20%20%20%20id%0A%20%20%20%20%20%20name%0A%20%20%20%20%20%20slug%0A%20%20%20%20%7D%0A%20%20%20%20timeOptions%20%7B%0A%20%20%20%20%20%20id%0A%20%20%20%20%20%20name%0A%20%20%20%20%7D%0A%20%20%20%20stageOptions%20%7B%0A%20%20%20%20%20%20id%0A%20%20%20%20%20%20name%0A%20%20%20%20%7D%0A%20%20%7D%0A%20%20subscribeUrl%0A%20%20isPremium%0A%20%20loginUrl%0A%7D%0A&operationName=getQuestionDetail&variables=%7B%22titleSlug%22%3A%22${2}%22%7D" > ${TMP_JSON_FILE} 

#    curl -s 'https://leetcode.com/graphql' \
#    -H 'origin: https://leetcode.com' \
#    -H 'accept-encoding: gzip, deflate, br' \
#    -H 'accept-language: zh-CN,zh;q=0.9,und;q=0.8,en;q=0.7' \
#    -H 'cookie: __atuvc=3%7C8%2C0%7C9%2C0%7C10%2C0%7C11%2C11%7C12; _ga=GA1.2.714733890.1464506754; __cfduid=d0091b1a13637142e21e82f5f43f8f3c61517304755; _gid=GA1.2.846248999.1517304756; csrftoken=W3F3gDMAmFE1024RMhNLUi0ofHb4gJ5Wqt4GcOaZHJKneSuXkY7kq2vHm6mA8f12; _gat=1' \
#    -H 'x-csrftoken: W3F3gDMAmFE1024RMhNLUi0ofHb4gJ5Wqt4GcOaZHJKneSuXkY7kq2vHm6mA8f12' \
#    -H 'pragma: no-cache' \
#    -H 'content-type: application/json' \
#    -H 'accept: */*' -H 'cache-control: no-cache' \
#    -H 'authority: leetcode.com' \
#    -H "referer: ${1}" \
#    --data-binary '{"operationName":"getQuestionDetail","variables":{"titleSlug":"'${2}'"},"query":"query getQuestionDetail($titleSlug: String!) {\n  isCurrentUserAuthenticated\n  question(titleSlug: $titleSlug) {\n    questionId\n    questionFrontendId\n    questionTitle\n    questionTitleSlug\n    content\n    difficulty\n    stats\n    contributors\n    companyTags\n    topicTags\n    similarQuestions\n    discussUrl\n    mysqlSchemas\n    randomQuestionUrl\n    sessionId\n    categoryTitle\n    submitUrl\n    interpretUrl\n    codeDefinition\n    sampleTestCase\n    enableTestMode\n    metaData\n    enableRunCode\n    enableSubmit\n    judgerAvailable\n    infoVerified\n    envInfo\n    urlManager\n    article\n    questionDetailUrl\n    discussCategoryId\n    discussSolutionCategoryId\n  }\n  interviewed {\n    interviewedUrl\n    companies {\n      id\n      name\n    }\n    timeOptions {\n      id\n      name\n    }\n    stageOptions {\n      id\n      name\n    }\n  }\n  subscribeUrl\n  isPremium\n  loginUrl\n}\n"}' --compressed > ${TMP_JSON_FILE}

    # xidel change the -q option to -s after 0.9.4 version, so we have to check that
    # if xidel has -q option, then it will return error. 

    OPT=

    set +e
    xidel -q 2>/dev/null
    if [ $? -ne 0 ]; then
       OPT=-q
    else
       # if xidel has -s option, then it will return error. 
       xidel -s 2>/dev/null
       if  [ $? -ne 0 ]; then
           OPT=-s
       fi
    fi 
    set -e

    QUESTION_CONTENT=$(xidel ${OPT} ${TMP_JSON_FILE} -e '$json("data").question.content' | sed -e 's/<[^>]*>//g; s/&nbsp;/ /g; s/&amp;/\&/g; s/&lt;/\</g; s/&gt;/\>/g; s/&quot;/\"/g; s/&#39;/\'"'"'/g; s/&ldquo;/\"/g;')

    QUESTION_DIFFICULTY=$(xidel ${OPT} ${TMP_JSON_FILE} -e '$json("data").question.difficulty')

    QUESTION_TITLE=$(xidel ${OPT} ${TMP_JSON_FILE} -e '$json("data").question.questionTitle')

    QUESTION_ID=$(xidel ${OPT} ${TMP_JSON_FILE} -e '$json("data").question.questionId')

    QUESTION_CATEGORY=$(xidel ${OPT} ${TMP_JSON_FILE} -e '$json("data").question.categoryTitle')
    
    rm -f $TMP_JSON_FILE
}

function detect_os()
{
    platform='unknown'
    ostype=`uname`
    if [[ "$ostype" == 'Linux' ]]; then
       platform='linux'
    elif [[ "$ostype" == 'Darwin' ]]; then
       platform='macos'
    fi
    echo ${platform}
}

function install_xidel()
{
    echo "Install xidel ..."
    if [ ! -d ./xidel ]; then
        mkdir xidel
    fi
    cd xidel

    platform=`detect_os`

    if [[ "$platform" == "unknown" ]]; then
        echo "Unknown platform, please install 'xidel' manually!"
        exit 1;
    fi

    #install the xidel on Linux platform
    xidel_ver=0.9.6
    if [[ "$platform" == "linux" ]]; then
        hardware=`uname -m`
        xidel_tar=xidel-${xidel_ver}.linux64.tar.gz
        case $hardware in
            x86_64 )    xidel_tar=xidel-${xidel_ver}.linux64.tar.gz
                        ;;
              i686 )    xidel_tar=xidel-${xidel_ver}.linux32.tar.gz
                        ;;
                 * )    echo "Cannot install xidel, please install it manually!"
                        exit 1;
        esac
        if [ ! -f ${xidel_tar} ]; then
            echo "Downloading xidel......"
            curl -s -L https://jaist.dl.sourceforge.net/project/videlibri/Xidel/Xidel%20${xidel_ver}/${xidel_tar} -o ${xidel_tar}
        fi
        tar -zxvf ${xidel_tar}
        sudo ./install.sh
    fi

    #install the xidel on MacOS platform
    #refer to: https://www.evernote.com/shard/s69/sh/ff1e78f3-a369-4855-b18f-6184ce789c45/f3511927d0fb356ce883835f2eb712e0
    if [[ "$platform" == "macos" ]]; then
        echo "Downloading xidel......"
        xidel_zip=xidel.zip
        if [ ! -f ${xidel_zip} ]; then
            curl -L https://www.evernote.com/shard/s69/sh/ff1e78f3-a369-4855-b18f-6184ce789c45/f3511927d0fb356ce883835f2eb712e0/res/de33e89a-cdc6-42b5-a476-32e2df1cf4bc/${xidel_zip} -o ${xidel_zip}
        fi
        unzip ${xidel_zip}
        mv xidel /usr/local/bin/
    fi

    cd ..
    echo "Install xidel successfullly !"
}
