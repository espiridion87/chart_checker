#!/usr/bin/env sh


#! /usr/bin/env bash
#
#/ Usage: chart_checker <chart> <index>
#/
#/
#/ OPTIONS
#/   -h, --help
#/                Print this help message
#/
#/ EXAMPLES
#/


#{{{ Bash settings
# abort on nonzero exitstatus
set -o errexit
# abort on unbound variable
set -o nounset
# don't hide errors within pipes
set -o pipefail
#}}}
#{{{ Variables
IFS=$'\t\n'   # Split on newlines and tabs (but not on spaces)
#}}}

main() {

    chart=$1
    index=$2
    appName=$(yq '.name' "$chart" )
    version=$(yq '.version' "$chart")

    chart_major=$(get_major "${version}")
    chart_minor=$(get_minor "${version}")
    chart_patch=$(get_patch "${version}")

    index_major=$(get_major_index "${appName}" "${index}")
    index_minor=$(get_minor_index "${appName}" "${index}" "${index_major}")
    index_patch=$(get_patch_index "${appName}" "${index}" "${index_major}" "${index_minor}")

    if [ "${chart_major}" -lt "${index_major}" ]; then
        error "Major version on chart is older than the last published"
        exit 1
    elif [ "${chart_major}" -eq "${index_major}" ]; then
        if [ "${chart_minor}" -lt "${index_minor}" ]; then
            error "Minor version on chart is older than the last published"
            exit 1
        elif [ "${chart_minor}" -eq "${index_minor}" ]; then
            if [ "${chart_patch}" -le "${index_patch}" ]; then
                error "Patch version on chart is older than the last published"
                exit 1
            fi
        fi
    fi
}

#{{{ Helper functions


error() {
    echo "${*}" 1>&2
}


get_major() {
    version=$1
    echo "${version}" | sed 's/\([[:digit:]]\+\)\..*/\1/'
}

get_minor() {
    version=$1
    echo "${version}" | sed 's/.*\.\([[:digit:]]\+\)\..*/\1/'
}

get_patch() {
    version=$1
    echo "${version}" | sed 's/.*\..*\.\([[:digit:]]\+\)/\1/'
}

get_major_index() {
    appName=$1
    index=$2

    allVersionsForAppName=".entries.${appName} | map(.version)"
    arrayOfMajorVersions='map(match("(\d+)\..*")) | map(.captures.[0].string) | unique | map(. tag = "!!int")'
    latestVersion="sort | reverse | .[0]"

    yq "${allVersionsForAppName} | ${arrayOfMajorVersions} | ${latestVersion}" "${index}"
}

get_minor_index() {
    appName=$1
    index=$2
    major=$3

    allMinorVerForAppANDMajor=".entries.${appName} | map(.version) | map(select(. == \"${major}.*\"))"
    minorSorted='map(match(".*\.(\d+)\..*")) | map(.captures.[0].string) | unique | map(. tag = "!!int")'
    latestVersion="sort | reverse | .[0]"

    yq "${allMinorVerForAppANDMajor} | ${minorSorted} | ${latestVersion}" "${index}"
}

get_patch_index() {
    appName=$1
    index=$2
    major=$3
    minor=$4

    allPatchMajorMinorApp=".entries.${appName} | map(.version) | map(select(. == \"${major}.${minor}.*\"))"
    pachMinor='map(match(".*\.(\d+)*")) | map(.captures.[0].string) | unique | map(. tag = "!!int")'
    latestVersion="sort | reverse | .[0]"

    yq "${allPatchMajorMinorApp} | ${pachMinor} | ${latestVersion}" "${index}"
}

#}}}

main "${@}"
