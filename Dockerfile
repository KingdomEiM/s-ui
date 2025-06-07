FROM debian:bookworm-slim

# نصب ابزارهای موردنیاز
RUN apt-get update && apt-get install -y \
    curl \
    bash \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# تنظیم دایرکتوری کاری
WORKDIR /usr/local/s-ui

# کپی فایل اجرایی
COPY s-ui-linux-amd64.tar.gz ./

# اکسترکت فایل باینری و حذف آرشیو
RUN tar -xzf s-ui-linux-amd64.tar.gz && \
    chmod +x s-ui && \
    rm s-ui-linux-amd64.tar.gz

# باز کردن پورت‌ها
EXPOSE 2095 2096

# اجرای فایل
CMD ["./s-ui"]
