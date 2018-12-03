class WolfPack extends Animal {
  ArrayList<Wolf> members;

  WolfPack(int _id, World _world, float _ex, float _ey, float _rot) {
    super(_id, _world, _ex, _ey, _rot); 
    setupPack();
  }
  WolfPack(Animal _a) {
    super(_a);
    setupPack();
  }
  WolfPack(Wolf _a) {
    super(_a);
    setupPack();
  }

  WolfPack(World _world) {
    super(_world);
    setupPack();
  }
  void setupPack() {
    members = new ArrayList<Wolf>();
    members.add(this);
  }

  void addMember(Wolf _a) {
    members.add(_a);
  }
  void addMember(Animal _a) {
    members.add(_a);
  }
  Wolf getMember(int _n) {
    return members.get(_n);
  }
  Wolf getAlpha() {
    return members.get(0);
  }
}
