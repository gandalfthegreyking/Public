#!/bin/bash

# Exit the script if a pipeline fails (-e), prevent accidental filename
# expansion (-f), and consider undefined variables as errors (-u).
set -e -f -u

# Env configuration
#
# DOMAIN_NAME       Main domain name we're obtaining a wildcard certificate for.
# DNS_PROVIDER      DNS provider lego uses to prove that you're in control of
# 					the domain. The current version supports the following hosts:
# 					"cloudflare", "digitalocean", "dreamhost", "duckdns" and "godaddy".
# EMAIL				Your email address.
#
# CloudFlare
# ---
# If you're using CloudFlare, you must specify the API token:
# https://developers.cloudflare.com/api/tokens/create
#
# CLOUDFLARE_DNS_API_TOKEN		Your API token.
#
#
# DigitalOcean
# ---
# If you're using DigitalOcean, you must specify the API token:
# https://cloud.digitalocean.com/account/api/tokens
#
# DO_AUTH_TOKEN		Your API token.
#
#
# DreamHost
# ---
# If you're using DreamHost you must specify the API key:
# https://panel.dreamhost.com/?tree=billing.api
#
# DREAMHOST_API_KEY     Your API key
#
#
# Duck DNS
# ---
# If you're using DuckDNS you must specify the API token
#
# DUCKDNS_TOKEN         Your API token
#
#
# GoDaddy
# ---
# If you're using GoDaddy, you must specify the API secret and key. The API
# credentials can be created here: https://developer.godaddy.com/keys
#
# GODADDY_API_KEY				API key.
# GODADDY_API_SECRET			API secret.

# Function error_exit is an echo wrapper that writes to stderr and stops the
# script execution with code 1.
error_exit() {
    echo "$1" 1>&2

    exit 1
}

# Function log is an echo wrapper that writes to stderr if the caller
# requested verbosity level greater than 0.  Otherwise, it does nothing.
log() {
    if [ "$verbose" -gt '0' ]; then
        echo "$1" 1>&2
    fi
}

check_env() {
    if [ -z "${DOMAIN_NAME+x}" ]; then
        error_exit "DOMAIN_NAME must be specified"
    fi

    if [ -z "${DNS_PROVIDER+x}" ]; then
        error_exit "DNS_PROVIDER must be specified"
    fi

    if [ -z "${EMAIL+x}" ]; then
        error_exit "EMAIL must be specified"
    fi

    if [ "${DNS_PROVIDER}" != 'godaddy' ] && "${DNS_PROVIDER}" != 'porkbun' ] && [ "${DNS_PROVIDER}" != 'cloudflare' ] && [ "${DNS_PROVIDER}" != 'digitalocean' ] && [ "${DNS_PROVIDER}" != "dreamhost" ] && [ "${DNS_PROVIDER}" != 'duckdns' ]; then
        error_exit "DNS provider ${DNS_PROVIDER} is not supported"
    fi

    if [ "${DNS_PROVIDER}" = 'cloudflare' ]; then
        if [ -z "${CLOUDFLARE_DNS_API_TOKEN+x}" ]; then
            error_exit "CLOUDFLARE_DNS_API_TOKEN must be specified"
        fi
    fi

    if [ "${DNS_PROVIDER}" = 'godaddy' ]; then
        if [ -z "${GODADDY_API_KEY+x}" ]; then
            error_exit "GODADDY_API_KEY must be specified"
        fi

        if [ -z "${GODADDY_API_SECRET+x}" ]; then
            error_exit "GODADDY_API_SECRET must be specified"
        fi
    fi

    if [ "${DNS_PROVIDER}" = 'porkbun' ]; then
        if [ -z "${PORKBUN_API_KEY+x}" ]; then
            error_exit "PORKBUN_API_KEY must be specified"
        fi

        if [ -z "${PORKBUN_SECRET_API_KEY+x}" ]; then
            error_exit "PORKBUN_SECRET_API_KEY must be specified"
        fi
    fi

    if [ "${DNS_PROVIDER}" = 'digitalocean' ]; then
        if [ -z "${DO_AUTH_TOKEN+x}" ]; then
            error_exit "DO_AUTH_TOKEN must be specified"
        fi
    fi

    if [ "${DNS_PROVIDER}" = 'dreamhost' ]; then
        if [ -z "${DREAMHOST_API_KEY+x}" ]; then
            error_exit "DREAMHOST_API_KEY must be specified"
        fi
    fi	

    if [ "${DNS_PROVIDER}" = 'duckdns' ]; then
        if [ -z "${DUCKDNS_TOKEN+x}" ]; then
            error_exit "DUCKDNS_TOKEN must be specified"
        fi
    fi	

}

run_lego_cloudflare() {
    if [ "${SERVER:-}" != "" ] &&
        [ "${EAB_KID:-}" != "" ] &&
        [ "${EAB_HMAC:-}" != "" ]; then
        CLOUDFLARE_DNS_API_TOKEN="${CLOUDFLARE_DNS_API_TOKEN}" \
            /home/kennyak/lego/dist/lego \
            --accept-tos \
            --server "${SERVER:-}" \
            --eab --kid "${EAB_KID:-}" --hmac "${EAB_HMAC:-}" \
            --dns cloudflare \
            --domains "${domainName1}" \
            --domains "${domainName2}" \
            --domains "${domainName3}" \
            --domains "${domainName4}" \
            --domains "${domainName5}" \
            --domains "${domainName6}" \
            --domains "${domainName7}" \
            --domains "${domainName8}" \
            --domains "${domainName9}" \
            --email "${email}" \
            --cert.timeout 600 \
            run
    else
        CLOUDFLARE_DNS_API_TOKEN="${CLOUDFLARE_DNS_API_TOKEN}" \
            /home/kennyak/lego/dist/lego \
            --accept-tos \
            --dns cloudflare \
            --domains "${domainName1}" \
            --domains "${domainName2}" \
            --domains "${domainName3}" \
            --domains "${domainName4}" \
            --domains "${domainName5}" \
            --domains "${domainName6}" \
            --domains "${domainName7}" \
            --domains "${domainName8}" \
            --domains "${domainName9}" \
            --email "${email}" \
            --cert.timeout 600 \
            run \
            --preferred-chain="ISRG Root X1"
    fi
}

run_lego_godaddy() {
    if [ "${SERVER:-}" != "" ] &&
        [ "${EAB_KID:-}" != "" ] &&
        [ "${EAB_HMAC:-}" != "" ]; then
        GODADDY_API_KEY="${GODADDY_API_KEY}" \
            GODADDY_API_SECRET="${GODADDY_API_SECRET}" \
            /home/kennyak/lego/dist/lego \
            --accept-tos \
            --server "${SERVER:-}" \
            --eab --kid "${EAB_KID:-}" --hmac "${EAB_HMAC:-}" \
            --dns godaddy \
            --domains "${domainName1}" \
            --domains "${domainName2}" \
            --domains "${domainName3}" \
            --domains "${domainName4}" \
            --domains "${domainName5}" \
            --domains "${domainName6}" \
            --domains "${domainName7}" \
            --domains "${domainName8}" \
            --domains "${domainName9}" \
            --email "${email}" \
            --cert.timeout 600 \
            run
    else
        GODADDY_API_KEY="${GODADDY_API_KEY}" \
            GODADDY_API_SECRET="${GODADDY_API_SECRET}" \
            /home/kennyak/lego/dist/lego \
            --accept-tos \
            --dns godaddy \
            --domains "${domainName1}" \
            --domains "${domainName2}" \
            --domains "${domainName3}" \
            --domains "${domainName4}" \
            --domains "${domainName5}" \
            --domains "${domainName6}" \
            --domains "${domainName7}" \
            --domains "${domainName8}" \
            --domains "${domainName9}" \
            --email "${email}" \
            --cert.timeout 600 \
            run \
            --preferred-chain="ISRG Root X1"
    fi
}

run_lego_porkbun() {
    if [ "${SERVER:-}" != "" ] &&
        [ "${EAB_KID:-}" != "" ] &&
        [ "${EAB_HMAC:-}" != "" ]; then
        PORKBUN_API_KEY="${PORKBUN_API_KEY}" \
            PORKBUN_SECRET_API_KEY="${PORKBUN_SECRET_API_KEY}" \
            /home/kennyak/lego/dist/lego \
            --accept-tos \
            --server "${SERVER:-}" \
            --eab --kid "${EAB_KID:-}" --hmac "${EAB_HMAC:-}" \
            --dns porkbun \
            --domains "${domainName1}" \
            --domains "${domainName2}" \
            --domains "${domainName3}" \
            --domains "${domainName4}" \
            --domains "${domainName5}" \
            --domains "${domainName6}" \
            --domains "${domainName7}" \
            --domains "${domainName8}" \
            --domains "${domainName9}" \
            --email "${email}" \
            --cert.timeout 600 \
            run
    else
        PORKBUN_API_KEY="${PORKBUN_API_KEY}" \
            PORKBUN_SECRET_API_KEY="${PORKBUN_SECRET_API_KEY}" \
            /home/kennyak/lego/dist/lego \
            --accept-tos \
            --dns porkbun \
            --domains "${domainName1}" \
            --domains "${domainName2}" \
            --domains "${domainName3}" \
            --domains "${domainName4}" \
            --domains "${domainName5}" \
            --domains "${domainName6}" \
            --domains "${domainName7}" \
            --domains "${domainName8}" \
            --domains "${domainName9}" \
            --email "${email}" \
            --cert.timeout 600 \
            run \
            --preferred-chain="ISRG Root X1"
    fi
}

run_lego_digitalocean() {
    if [ "${SERVER:-}" != "" ] &&
        [ "${EAB_KID:-}" != "" ] &&
        [ "${EAB_HMAC:-}" != "" ]; then
        DO_AUTH_TOKEN="${DO_AUTH_TOKEN}" \
            /home/kennyak/lego/dist/lego \
            --accept-tos \
            --server "${SERVER:-}" \
            --eab --kid "${EAB_KID:-}" --hmac "${EAB_HMAC:-}" \
            --dns digitalocean \
            --domains "${domainName1}" \
            --domains "${domainName2}" \
            --domains "${domainName3}" \
            --domains "${domainName4}" \
            --domains "${domainName5}" \
            --domains "${domainName6}" \
            --domains "${domainName7}" \
            --domains "${domainName8}" \
            --domains "${domainName9}" \
            --email "${email}" \
            --cert.timeout 600 \
            run
    else
        DO_AUTH_TOKEN="${DO_AUTH_TOKEN}" \
            /home/kennyak/lego/dist/lego \
            --accept-tos \
            --dns digitalocean \
            --domains "${domainName1}" \
            --domains "${domainName2}" \
            --domains "${domainName3}" \
            --domains "${domainName4}" \
            --domains "${domainName5}" \
            --domains "${domainName6}" \
            --domains "${domainName7}" \
            --domains "${domainName8}" \
            --domains "${domainName9}" \
            --email "${email}" \
            --cert.timeout 600 \
            run \
            --preferred-chain="ISRG Root X1"
    fi
}

run_lego_dreamhost() {
    if [ "${SERVER:-}" != "" ] &&
        [ "${EAB_KID:-}" != "" ] &&
        [ "${EAB_HMAC:-}" != "" ]; then
        DREAMHOST_API_KEY="${DREAMHOST_API_KEY}" \
            /home/kennyak/lego/dist/lego \
            --accept-tos \
            --server "${SERVER:-}" \
            --eab --kid "${EAB_KID:-}" --hmac "${EAB_HMAC:-}" \
            --dns dreamhost \
            --domains "${domainName1}" \
            --domains "${domainName2}" \
            --domains "${domainName3}" \
            --domains "${domainName4}" \
            --domains "${domainName5}" \
            --domains "${domainName6}" \
            --domains "${domainName7}" \
            --domains "${domainName8}" \
            --domains "${domainName9}" \
            --email "${email}" \
            --cert.timeout 600 \
            run
    else
        DREAMHOST_API_KEY="${DREAMHOST_API_KEY}" \
            /home/kennyak/lego/dist/lego \
            --accept-tos \
            --dns dreamhost \
            --domains "${domainName1}" \
            --domains "${domainName2}" \
            --domains "${domainName3}" \
            --domains "${domainName4}" \
            --domains "${domainName5}" \
            --domains "${domainName6}" \
            --domains "${domainName7}" \
            --domains "${domainName8}" \
            --domains "${domainName9}" \
            --email "${email}" \
            --cert.timeout 600 \
            run \
            --preferred-chain="ISRG Root X1"
    fi
}

run_lego_duckdns() {
    if [ "${SERVER:-}" != "" ] &&
        [ "${EAB_KID:-}" != "" ] &&
        [ "${EAB_HMAC:-}" != "" ]; then
        DUCKDNS_TOKEN="${DUCKDNS_TOKEN}" \
            /home/kennyak/lego/dist/lego \
            --accept-tos \
            --server "${SERVER:-}" \
            --eab --kid "${EAB_KID:-}" --hmac "${EAB_HMAC:-}" \
            --dns duckdns \
            --domains "${domainName1}" \
            --domains "${domainName2}" \
            --domains "${domainName3}" \
            --domains "${domainName4}" \
            --domains "${domainName5}" \
            --domains "${domainName6}" \
            --domains "${domainName7}" \
            --domains "${domainName8}" \
            --domains "${domainName9}" \
            --email "${email}" \
            --cert.timeout 600 \
            run
    else
        DUCKDNS_TOKEN="${DUCKDNS_TOKEN}" \
            /home/kennyak/lego/dist/lego \
            --accept-tos \
            --dns duckdns \
            --domains "${domainName1}" \
            --domains "${domainName2}" \
            --domains "${domainName3}" \
            --domains "${domainName4}" \
            --domains "${domainName5}" \
            --domains "${domainName6}" \
            --domains "${domainName7}" \
            --domains "${domainName8}" \
            --domains "${domainName9}" \
            --email "${email}" \
            --cert.timeout 600 \
            run \
            --preferred-chain="ISRG Root X1"
    fi
}

run_lego() {
    domainName1="${DOMAIN_NAME1}"
    domainName2="${DOMAIN_NAME2}"
    domainName3="${DOMAIN_NAME3}"
    domainName4="${DOMAIN_NAME4}"
    domainName5="${DOMAIN_NAME6}"
    domainName6="${DOMAIN_NAME6}"
    domainName7="${DOMAIN_NAME7}"
    domainName8="${DOMAIN_NAME8}"
    domainName9="${DOMAIN_NAME9}"
    email="${EMAIL}"

    case ${DNS_PROVIDER} in

    porkbun)
        run_lego_porkbun
        ;;

    godaddy)
        run_lego_godaddy
        ;;

    cloudflare)
        run_lego_cloudflare
        ;;

    digitalocean)
    	run_lego_digitalocean
    	;;

    dreamhost)
        run_lego_dreamhost
        ;;

    duckdns)
    	run_lego_duckdns
    	;;

    *)
        error_exit "Unsupported DNS provider ${DNS_PROVIDER}"
        ;;
    esac
}

get_abs_filename() {
    echo "$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
}

copy_certificate() {
    certFileName="${DOMAIN_NAME1}"
    \cp -r "/home/kennyak/lego/.lego/certificates/${certFileName}.key" "/opt/ssl/${certFileName}.key"
    \cp -r "/home/kennyak/lego/.lego/certificates/${certFileName}.crt" "/opt/ssl/${certFileName}.crt"

    log "Your certificate and key are available at:"
    log "$("/home/kennyak/lego/.lego/certificates/${certFileName}.crt")"
    log "$("/home/kennyak/lego/.lego/certificates/${certFileName}.key")"
}

# Entrypoint

# Set default values of configuration variables.
verbose='1'
domainName1=''
domainName2=''
domainName3=''
domainName4=''
domainName5=''
domainName6=''
domainName7=''
domainName8=''
domainName9=''
email=''

check_env

run_lego

copy_certificate