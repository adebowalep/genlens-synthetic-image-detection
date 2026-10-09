"""GenLens: explainable and robust synthetic-image detection."""
# Import torch before sklearn/scipy/matplotlib: on some macOS builds loading them in the other order
# loads two OpenMP runtimes and segfaults (observed in drift analysis).
import torch  # noqa: F401

__version__ = "0.1.0"
