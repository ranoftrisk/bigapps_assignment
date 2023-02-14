import 'package:bigapps_assignment/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_draggable_gridview/flutter_draggable_gridview.dart';
import 'package:flutter_svg/svg.dart';
import '../../blocs/user_display/user_display_bloc.dart';
import '../../utils/styles.dart';

class UserDisplayRootPage extends StatefulWidget {
  const UserDisplayRootPage({Key? key}) : super(key: key);

  @override
  State<UserDisplayRootPage> createState() => _UserDisplayRootPageState();
}

class _UserDisplayRootPageState extends State<UserDisplayRootPage>
    with TickerProviderStateMixin {
  late AnimationController _alphaBethController;
  late AnimationController _numericController;
  @override
  void initState() {
    _alphaBethController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      upperBound: 0.5,
    );
    _numericController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      upperBound: 0.5,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserDisplayBloc>(
        create: (context) => UserDisplayBloc()..add(FetchUserDataEvent()),
        child: BlocBuilder<UserDisplayBloc, UserDisplayState>(
            builder: (context, state) {
          final grids = context.read<UserDisplayBloc>().grids;
          if (state is LoadingUserDisplayState || grids.isEmpty) {
            return Scaffold(
                appBar: AppBar(
                  title: const Text(
                    'User List',
                    style: Styles.kHeadlineTextStyle,
                  ),
                  backgroundColor: Styles.kAppBarBackgroundColor,
                ),
                body: Center(child: const CircularProgressIndicator()));
          }
          final displayBloc = context.read<UserDisplayBloc>();
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'User List',
                style: Styles.kHeadlineTextStyle,
              ),
              backgroundColor: Styles.kAppBarBackgroundColor,
              actions: [
                RotationTransition(
                  turns:
                      Tween(begin: 0.0, end: 1.0).animate(_alphaBethController),
                  child: IconButton(
                      onPressed: () {
                        displayBloc.add(SortUsersByAlphabetUserDataEvent());
                        final isUpside = displayBloc.isAlphabetUpsideDown;
                        animateSortIcon(
                            displayBloc, isUpside, _alphaBethController);
                      },
                      icon: SvgPicture.asset(Assets.kSortAlpha)),
                ),
                RotationTransition(
                  turns:
                      Tween(begin: 0.0, end: 1.0).animate(_numericController),
                  child: IconButton(
                      onPressed: () {
                        displayBloc.add(SortNumericUserDataEvent());
                        final isUpside = displayBloc.isNumericUpsideDown;
                        animateSortIcon(
                            displayBloc, isUpside, _numericController);
                      },
                      icon: SvgPicture.asset(Assets.kSortNumeric)),
                ),
                const SizedBox(
                  width: 32,
                )
              ],
            ),
            body: SafeArea(
                child: DraggableGridViewBuilder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12),
              dragCompletion: (List<DraggableGridItem> list, int beforeIndex,
                  int afterIndex) {},
              children: grids,
              dragFeedback: feedback,
              padding: EdgeInsets.all(20),
            )),
          );
        }));
  }

  Widget feedback(List<DraggableGridItem> list, int index) {
    return Container(
      width: 200,
      height: 200,
      child: list[index].child,
    );
  }

  void animateSortIcon(UserDisplayBloc displayBloc, bool isUpside,
      AnimationController controller) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        setState(() {
          if (isUpside) {
            controller.reverse(from: 0.5);
          } else {
            controller.forward(from: 0.0);
          }
        });
      });
    });
  }

  @override
  void dispose() {
    _numericController.dispose();
    _alphaBethController.dispose();
    super.dispose();
  }
}
