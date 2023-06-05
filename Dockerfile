FROM rocker/rstudio AS base

# COPY --from=shiny /rocker_scripts/install_shiny_server.sh /rocker_scripts/install_shiny_server.sh
# RUN /rocker_scripts/install_shiny_server.sh
ENV NCPUS="-1"
RUN install2.r --error --skipinstalled -n "$NCPUS" shiny rmarkdown renv
RUN install2.r --error --skipinstalled -n "$NCPUS" shinyWidgets
RUN install2.r --error --skipinstalled -n "$NCPUS" shinythemes
ENV DISABLE_AUTH=true