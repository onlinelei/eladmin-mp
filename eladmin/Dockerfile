# 使用包含 Git 和 Maven 的基础镜像
FROM maven:3.8.4-openjdk-8 AS builder

# 设置工作目录
WORKDIR /app

# 复制 pom.xml 文件并安装依赖
COPY pom.xml .

# 复制所有子模块的 pom.xml 文件
COPY eladmin-common/pom.xml eladmin-common/
COPY eladmin-generator/pom.xml eladmin-generator/
COPY eladmin-logging/pom.xml eladmin-logging/
COPY eladmin-system/pom.xml eladmin-system/
COPY eladmin-tools/pom.xml eladmin-tools/

# 复制源代码
COPY eladmin-common/src ./eladmin-common/src
COPY eladmin-generator/src ./eladmin-generator/src
COPY eladmin-logging/src ./eladmin-logging/src
COPY eladmin-system/src ./eladmin-system/src
COPY eladmin-tools/src ./eladmin-tools/src

# 构建项目
RUN mvn clean install package -DskipTests -U -Dmaven.repo.remote=https://maven.aliyun.com/repository/central

# 使用 openjdk 镜像作为最终运行环境
FROM openjdk:8

# 设置工作目录
WORKDIR /app

# 从 builder 阶段复制构建好的 jar 文件
COPY --from=builder /app/eladmin-system/target/eladmin-system-1.1.jar app.jar

# 设置时区
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 暴露端口
EXPOSE 8080

# 启动应用
ENTRYPOINT ["java", "-jar", "app.jar", "--spring.profiles.active=prod"]
