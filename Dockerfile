# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM ubuntu:16.04

MAINTAINER Tin Lam <tin@irrational.io>

ENV DEBIAN_FRONTEND=noninteractive \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8 \
    container=docker \
    XDG_RUNTIME_DIR=/run/user/0
COPY entrypoint.sh /usr/local/bin
VOLUME /var/lib/dirsrv \
VOLUME /etc/389-ds
ADD setup.inf /etc/389-ds/setup.inf
VOLUME /etc/dogtag
ADD ca.cfg /etc/dogtag/ca.cfg
ADD kra.cfg /etc/dogtag/kra.cfg
RUN rm -rf /var/lock /usr/lib/systemd/system \
    && apt-get update && apt-get install -y --no-install-recommends \
        389-ds-base \
        dogtag-pki \
        sudo \
        systemd \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base \
    && chmod a+x /usr/local/bin/entrypoint.sh \
    && chmod a+x /etc/dirsrv/config \
    && sed -i 's/checkHostname {/checkHostname {\nreturn();/g' /usr/lib/x86_64-linux-gnu/dirsrv/perl/DSUtil.pm \
    && groupadd -r barbican && useradd --no-log-init -r -g barbican ubuntu \
    && adduser ubuntu sudo \
    && echo "ubuntu ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
USER ubuntu:barbican

EXPOSE 8373 8370 8379 8375 389

ENTRYPOINT ["entrypoint.sh"]
