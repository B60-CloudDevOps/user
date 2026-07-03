FROM            docker.io/redhat/ubi9:9.8-1781496985
RUN             dnf module disable nodejs -y && \
                dnf module enable nodejs:22 -y && \
                dnf install -y nodejs && \
                dnf clean all
RUN             useradd -u 1000 roboshop 
RUN             mkdir /app && chown -R roboshop:roboshop /app
WORKDIR         /app
USER            roboshop
ADD             ./ /app/
# Ensure npm install is exectued to generate the node_modules directory and install all dependencies. This will be executed as a non-root user. But using security context at pod level, we will enforce to run it as non-root user
ADD             ./node_modules/ node_modules/
ENTRYPOINT      ["node", "/app/server.js"]
EXPOSE          8080
# This is how we can run container using roboshop account at container level;,But its perferred to deal at POD using PodSecurityContext