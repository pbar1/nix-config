#!/usr/bin/env bash

#------------------------------------------------------------------------------
# Generates a GPG keypair and saves it in 1Password.
# NOTE: Assumes you have already run `op signin`.
#
# https://www.gnupg.org/documentation/manuals/gnupg/OpenPGP-Key-Management.html
#------------------------------------------------------------------------------

set -o nounset -o errexit -o pipefail

function main() {
  local tmp="$(mktemp -d)"
  local name="$(git config --get user.name)"
  local email="$(git config --get user.email)"
  local secret="GPG: ${email}"
  local user_id="${name} <${email}>"
  local algo="rsa4096"
  local expire="never"

  # Create an entry in 1Password for the key and generate a passphrase
  op item create --title="${secret}" --category=password --generate-password
  local pass="$(op item get "${secret}" --fields=label=password)"
  local pass_flags="--batch --pinentry-mode=loopback --passphrase=${pass}"

  # Use an ephemeral GPG directory to avoid adding keys to our default keyring
  export GNUPGHOME="${tmp}"

  # Generate the root key
  gpg ${pass_flags} --quick-generate-key "${user_id}" "${algo}" cert "${expire}"

  # Find fingerprint of the root key
  local fpr
  fpr="$(gpg --list-keys --with-colons | awk -F: '/fpr/ { print $10 }')"

  # Add subkeys for signing, encryption, and authentication to our new key
  gpg ${pass_flags} --quick-add-key "${fpr}" "${algo}" sign "${expire}"
  gpg ${pass_flags} --quick-add-key "${fpr}" "${algo}" encr "${expire}"
  gpg ${pass_flags} --quick-add-key "${fpr}" "${algo}" auth "${expire}"

  # Export the keys into ASCII format
  gpg --armor --export --output="${tmp}/publickey.asc" "${user_id}"
  gpg ${pass_flags} --armor --export-secret-subkeys --output="${tmp}/secretsubkeys.asc" "${user_id}"
  gpg ${pass_flags} --armor --export-secret-keys --output="${tmp}/secretkey.asc" "${user_id}"

  # Save the ASCII-formatted keys to 1Password
  op item edit "${secret}"                                      \
    "GPG.email[email]=${email}"                                 \
    "GPG.publickey[text]=$(cat "${tmp}/publickey.asc")"         \
    "GPG.secretsubkeys[text]=$(cat "${tmp}/secretsubkeys.asc")" \
    "GPG.secretkey[text]=$(cat "${tmp}/secretkey.asc")"

  # Delete the ephemeral GPG directory
  rm -rf "${tmp}"
}

main
