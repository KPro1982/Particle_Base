class DistanceComparator implements Comparator<Entity> {
  Entity center;

  DistanceComparator(Entity _center) {
    center = _center;
  }

  int compare(Entity a, Entity b) {
    float dB = center.getParticle().distanceTo(a.getParticle());
    float dA = center.getParticle().distanceTo(b.getParticle());
    return int(dB - dA);
  }
}
