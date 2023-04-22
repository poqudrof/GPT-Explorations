# Use the official Ruby 3 Alpine image as the base image
FROM ruby:3.1.4-alpine3.17

# Create a new user and group called 'appuser' with no home directory
RUN addgroup -S appuser && adduser -S appuser -G appuser

# Set the working directory in the container
WORKDIR /home/appuser
RUN chown appuser:appuser /home/appuser

# Copy the Gemfile and Gemfile.lock into the working directory
# COPY Gemfile ./
COPY Gemfile Gemfile.lock ./

# Install build dependencies, bundle the gems, and remove build dependencies
# RUN apk add --no-cache --virtual .build-deps build-base \
#     && bundle install \
#     && apk del .build-deps
USER appuser

# RUN bundle install
# Copy the rest of the application code into the working directory

# COPY --chown=appuser:appuser app.rb ./
# Expose the port that the application will run on
# EXPOSE 3000

# Start the application
# CMD ["bundle", "install"]
CMD ["ruby", "app.rb"]